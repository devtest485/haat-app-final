package com.mycompany.haat

import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import android.util.Base64
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.Signature
import java.security.spec.ECGenParameterSpec
import java.util.concurrent.atomic.AtomicBoolean

/**
 * The half of biometric sign-in that cannot be written in Dart.
 *
 * The backend trusts a *device*, not a fingerprint: it stores the public half of a P-256
 * pair and later checks an ECDSA signature over a challenge it issued. That is only worth
 * something if the private half cannot be read, which is what the Android Keystore
 * provides and what a key generated in Dart would not — a key in the app's own storage
 * can be copied off a rooted handset, and copying it defeats the whole design while
 * leaving the screens looking finished.
 *
 * So the key is generated inside the Keystore with `setUserAuthenticationRequired`, and
 * the only way to reach it is a [BiometricPrompt] holding the [Signature] as its crypto
 * object. No fingerprint reaches this code: what the sensor unlocks is the ability to
 * sign, once.
 *
 * `setInvalidatedByBiometricEnrollment` is deliberate too. Enrolling a new finger or face
 * destroys the key, so somebody who adds their own biometric to an unlocked phone gets a
 * key that no longer signs rather than one that now signs for them. The app is told, and
 * asks the owner to enrol again.
 */
class BiometricKeyBridge(private val activity: FragmentActivity) :
    MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.mycompany.haat/biometric_key"

        private const val KEY_ALIAS = "haat.biometric.signing"
        private const val KEYSTORE = "AndroidKeyStore"

        /**
         * Codes the Dart side switches on. Strings rather than numbers because they cross
         * a channel and end up in logs, where `not_enrolled` is readable and `3` is not.
         */
        private const val ERROR_NO_HARDWARE = "no_hardware"
        private const val ERROR_NOT_ENROLLED = "not_enrolled"
        private const val ERROR_CANCELLED = "cancelled"
        private const val ERROR_KEY_UNSUPPORTED = "key_unsupported"
        private const val ERROR_KEY_INVALIDATED = "key_invalidated"
        private const val ERROR_PLATFORM = "platform_error"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "hasKey" -> result.success(loadPrivateKey() != null)
            "availability" -> result.success(availability())
            "enrol" -> enrol(result)
            "sign" -> {
                val challenge = call.argument<String>("challenge")

                if (challenge.isNullOrEmpty()) {
                    result.error(ERROR_PLATFORM, "A challenge is required", null)
                } else {
                    sign(
                        challenge,
                        call.argument<String>("title") ?: "Confirm it is you",
                        call.argument<String>("reason") ?: "Sign in to HAAT",
                        call.argument<String>("negative") ?: "Cancel",
                        result,
                    )
                }
            }
            "remove" -> {
                deleteKey()
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    /** Null when a strong biometric is usable, otherwise the reason it is not. */
    private fun availability(): String? =
        when (
            BiometricManager.from(activity)
                .canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)
        ) {
            BiometricManager.BIOMETRIC_SUCCESS -> null
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> ERROR_NOT_ENROLLED
            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE,
            BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE,
            -> ERROR_NO_HARDWARE
            // A pending security update or an unknown verdict are both "not now" rather
            // than "never", and neither is something the owner can act on from here.
            else -> ERROR_PLATFORM
        }

    private fun enrol(result: MethodChannel.Result) {
        // Checked against BIOMETRIC_STRONG specifically, not "has any biometric". A
        // weak-only face unlock passes the general check and then cannot gate a Keystore
        // key, so the general question would turn into a confusing failure later.
        availability()?.let {
            return result.error(it, "Biometrics are not available", null)
        }

        try {
            // One enrolment per device. A leftover key would keep signing for a public
            // half the server has since replaced, which reads as a rejected signature
            // with no way for anyone to see why.
            deleteKey()

            val specification = KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                KeyProperties.PURPOSE_SIGN,
            )
                .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
                .setDigests(KeyProperties.DIGEST_SHA256)
                .setUserAuthenticationRequired(true)
                .setInvalidatedByBiometricEnrollment(true)
                .apply {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        // Zero seconds means every use needs a fresh prompt, and naming
                        // BIOMETRIC_STRONG keeps a device PIN from standing in for one.
                        setUserAuthenticationParameters(
                            0,
                            KeyProperties.AUTH_BIOMETRIC_STRONG,
                        )
                    } else {
                        @Suppress("DEPRECATION")
                        setUserAuthenticationValidityDurationSeconds(-1)
                    }
                }
                .build()

            val generator =
                KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, KEYSTORE)
            generator.initialize(specification)

            // `encoded` on an EC public key is already X.509 SubjectPublicKeyInfo, which
            // is exactly what `POST /auth/biometric` parses.
            val publicKey = generator.generateKeyPair().public.encoded

            result.success(Base64.encodeToString(publicKey, Base64.NO_WRAP))
        } catch (error: Throwable) {
            result.error(
                ERROR_KEY_UNSUPPORTED,
                error.message ?: "This device could not create a hardware key",
                null,
            )
        }
    }

    private fun sign(
        challenge: String,
        title: String,
        reason: String,
        negative: String,
        result: MethodChannel.Result,
    ) {
        val privateKey = loadPrivateKey()
            ?: return result.error(
                ERROR_KEY_UNSUPPORTED,
                "No device key is enrolled",
                null,
            )

        val signature = try {
            Signature.getInstance("SHA256withECDSA").apply { initSign(privateKey) }
        } catch (invalidated: KeyPermanentlyInvalidatedException) {
            // The biometrics on this phone are not the ones the key was bound to. The key
            // is already useless, so it is cleared here rather than left to fail again.
            deleteKey()

            return result.error(
                ERROR_KEY_INVALIDATED,
                invalidated.message ?: "The device key is no longer valid",
                null,
            )
        } catch (error: Throwable) {
            return result.error(ERROR_PLATFORM, error.message ?: "Could not sign", null)
        }

        // A prompt can report more than once — a cancellation racing a success, an error
        // arriving after the sheet is already gone. Replying twice on a MethodChannel
        // kills the engine, so the first answer wins and the rest are dropped.
        val answered = AtomicBoolean(false)

        val prompt = BiometricPrompt(
            activity,
            ContextCompat.getMainExecutor(activity),
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(
                    authentication: BiometricPrompt.AuthenticationResult,
                ) {
                    if (!answered.compareAndSet(false, true)) return

                    val signer = authentication.cryptoObject?.signature
                        ?: return result.error(
                            ERROR_PLATFORM,
                            "The prompt returned no signer",
                            null,
                        )

                    try {
                        // Signed as the bytes of the string the server sent. The server
                        // verifies the same way, so neither side may decode the hex into
                        // bytes first.
                        signer.update(challenge.toByteArray(Charsets.UTF_8))

                        result.success(
                            Base64.encodeToString(signer.sign(), Base64.NO_WRAP),
                        )
                    } catch (error: Throwable) {
                        result.error(ERROR_PLATFORM, error.message ?: "Signing failed", null)
                    }
                }

                override fun onAuthenticationError(code: Int, message: CharSequence) {
                    if (!answered.compareAndSet(false, true)) return

                    result.error(errorCodeFor(code), message.toString(), null)
                }

                // onAuthenticationFailed is deliberately not overridden: a finger that did
                // not match leaves the prompt up for another try, so there is nothing to
                // report to Dart yet.
            },
        )

        val info = BiometricPrompt.PromptInfo.Builder()
            .setTitle(title)
            .setSubtitle(reason)
            .setNegativeButtonText(negative)
            .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
            // No second tap to confirm. The signature is the confirmation, and the screen
            // behind the prompt already says what is about to happen.
            .setConfirmationRequired(false)
            .build()

        prompt.authenticate(info, BiometricPrompt.CryptoObject(signature))
    }

    private fun errorCodeFor(code: Int): String = when (code) {
        BiometricPrompt.ERROR_NEGATIVE_BUTTON,
        BiometricPrompt.ERROR_USER_CANCELED,
        BiometricPrompt.ERROR_CANCELED,
        -> ERROR_CANCELLED
        BiometricPrompt.ERROR_NO_BIOMETRICS -> ERROR_NOT_ENROLLED
        BiometricPrompt.ERROR_HW_NOT_PRESENT,
        BiometricPrompt.ERROR_HW_UNAVAILABLE,
        -> ERROR_NO_HARDWARE
        else -> ERROR_PLATFORM
    }

    private fun loadPrivateKey(): PrivateKey? = try {
        val store = KeyStore.getInstance(KEYSTORE).apply { load(null) }

        store.getKey(KEY_ALIAS, null) as? PrivateKey
    } catch (_: Throwable) {
        // An unreadable Keystore is indistinguishable from an empty one from here, and
        // both mean the same thing to the caller: this device has no key.
        null
    }

    private fun deleteKey() {
        try {
            KeyStore.getInstance(KEYSTORE).apply { load(null) }.deleteEntry(KEY_ALIAS)
        } catch (_: Throwable) {
            // Nothing useful to do. Enrolling again overwrites the alias anyway.
        }
    }
}
