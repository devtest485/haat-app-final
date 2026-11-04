package com.mycompany.haat

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import android.Manifest
import android.app.Activity
import android.app.KeyguardManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.cardemulation.HostApduService
import android.nfc.tech.IsoDep
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import org.json.JSONObject
import java.io.IOException
import java.math.BigDecimal
import java.net.HttpURLConnection
import java.net.URL
import java.text.DecimalFormat
import java.util.Currency
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import android.util.Base64
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
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
 * A [FlutterFragmentActivity], not a `FlutterActivity`.
 *
 * `BiometricPrompt` is a fragment and needs a `FragmentActivity` to attach to; so does
 * `local_auth`. On a plain `FlutterActivity` both fail at the moment the prompt is shown,
 * which is the worst place to find out.
 */
class MainActivity : FlutterFragmentActivity() {
    private var tap: TapBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BiometricKeyBridge.CHANNEL,
        ).setMethodCallHandler(BiometricKeyBridge(this))

        tap = TapBridge(this).also {
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TapBridge.CHANNEL)
                .setMethodCallHandler(it)
        }
    }

    override fun onResume() {
        super.onResume()
        TapKeys.foreground = true
        // Reader mode belongs to the foreground activity; a merchant who glanced at a
        // notification mid-sale comes back to a phone that is still reading.
        tap?.resume()
    }

    override fun onPause() {
        TapKeys.foreground = false
        super.onPause()
    }
}

// ---------------------------------------------------------------------------
// BiometricKeyBridge lived in its own file under the same package. FlutterFlow
// exposes only four Android files — AndroidManifest.xml, proguard-rules.pro,
// build.gradle and MainActivity.kt — and there is no way to add a fifth, so the
// class is inlined here. Kotlin allows several classes per file; without this
// MainActivity fails to build with "Unresolved reference: BiometricKeyBridge".
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Tap to pay. Both halves live here for the same reason BiometricKeyBridge does.
//
// The phone that made the tap pays the phone held to it. The phone being paid is the
// card: HaatTapService answers over NFC by signing the tap's code, amount and
// currency, with a key that never leaves the Keystore — saying whose phone it is. The
// paying phone is the terminal: TapBridge reads that answer and hands it to Dart,
// which pays with it.
// ---------------------------------------------------------------------------

/** This phone's tap key, what it is paid by tap with, and the id the server gave it. */
object TapKeys {
    /** "F0" for a proprietary AID, then HAATPAY. Also in haat_tap_service.xml. */
    val AID = "F048414154504159".chunked(2).map { it.toInt(16).toByte() }.toByteArray()

    private const val KEY_ALIAS = "haat.tap.signing"
    private const val KEYSTORE = "AndroidKeyStore"
    private const val PREFERENCES = "haat.tap"

    private fun preferences(context: Context) =
        context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)

    fun keyId(context: Context): String? = preferences(context).getString("keyId", null)

    fun userId(context: Context): String? = preferences(context).getString("userId", null)

    /** HAAT is on screen. A tap with it closed is answered only when [background] is on. */
    @Volatile
    var foreground = false

    /**
     * The owner's choice under Security: this phone is paid by tap with the screen
     * locked, or off, or HAAT closed — answered without opening HAAT, and told by a
     * notification. Off, HAAT has to be open to be paid by tap.
     */
    fun background(context: Context): Boolean =
        preferences(context).getBoolean("background", false)

    /** Where to ask what a tap paid, with HAAT closed: the app's API base URL. */
    fun apiBase(context: Context): String? = preferences(context).getString("apiBase", null)

    fun setBackground(context: Context, on: Boolean, apiBase: String?) {
        val editor = preferences(context).edit().putBoolean("background", on)
        if (!apiBase.isNullOrBlank()) editor.putString("apiBase", apiBase.trimEnd('/'))
        editor.apply()
    }

    /**
     * A new key, its public half as SPKI base64.
     *
     * Not behind the fingerprint: a tap has to work with the phone just unlocked, as a
     * card does. It only says who is being paid; the paying phone was unlocked first.
     */
    fun enrol(context: Context): String {
        // The key only: the owner's choice under Security stays with the phone.
        preferences(context).edit().remove("keyId").remove("userId").apply()
        deleteKey()

        val specification = KeyGenParameterSpec.Builder(KEY_ALIAS, KeyProperties.PURPOSE_SIGN)
            .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
            .setDigests(KeyProperties.DIGEST_SHA256)
            .build()
        val generator = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, KEYSTORE)
        generator.initialize(specification)

        return Base64.encodeToString(generator.generateKeyPair().public.encoded, Base64.NO_WRAP)
    }

    fun save(context: Context, keyId: String, userId: String) {
        preferences(context).edit().putString("keyId", keyId).putString("userId", userId).apply()
    }

    /** Signed out: the key, and the choice to be paid while locked, both go. */
    fun forget(context: Context) {
        preferences(context).edit().clear().apply()
        deleteKey()
    }

    private fun deleteKey() {
        try {
            KeyStore.getInstance(KEYSTORE).apply { load(null) }.deleteEntry(KEY_ALIAS)
        } catch (_: Throwable) {
        }
    }

    fun privateKey(): PrivateKey? = try {
        KeyStore.getInstance(KEYSTORE).apply { load(null) }.getKey(KEY_ALIAS, null) as? PrivateKey
    } catch (_: Throwable) {
        null
    }

    /** What a tap signs. The server builds the same string — see wallet-pay.controller. */
    fun message(code: String, amountMinor: String, currency: String) =
        "HAAT-TAP-1|$code|$amountMinor|$currency"

    /** What this phone signs to ask what tap [code] paid it — nothing a tap pays with. */
    fun resultMessage(code: String) = "HAAT-TAP-RESULT-1|${code.uppercase()}"

    fun sign(key: PrivateKey, message: String): String {
        val signer = Signature.getInstance("SHA256withECDSA").apply {
            initSign(key)
            update(message.toByteArray(Charsets.UTF_8))
        }
        return Base64.encodeToString(signer.sign(), Base64.NO_WRAP)
    }
}

/**
 * The half being paid: the phone as a card.
 *
 * Android routes a reader's SELECT for our AID here, and only while the phone is
 * unlocked (`requireDeviceUnlock`). The reader then sends one PAY command — the
 * request's code, amount and currency — and gets back the key id and a signature over
 * exactly those. Nothing else can be asked of it.
 *
 * Then the app opens on the tap, to show what this phone was paid. (`confirm`, an
 * approval on this screen, is from when the tapped phone paid; nothing asks for it.)
 *
 * With HAAT closed, or the phone locked, it answers only if the owner turned that on
 * under Security ([TapKeys.background]); otherwise SELECT is refused with `6986`, which
 * the paying phone reads as "open HAAT". When it does answer, HAAT stays closed: what
 * the tap paid is asked of HAAT by [TapNotice], and told in a notification.
 */
class HaatTapService : HostApduService() {
    companion object {
        private val OK = byteArrayOf(0x90.toByte(), 0x00)
        private val NOT_SET_UP = byteArrayOf(0x6A, 0x82.toByte())
        private val REFUSED = byteArrayOf(0x69, 0x85.toByte())
        private val UNKNOWN = byteArrayOf(0x6D, 0x00)
        private val CODE = Regex("^[A-Za-z0-9_-]{4,64}$")
        private val AMOUNT = Regex("^[0-9]{1,18}$")
        private val CURRENCY = Regex("^[A-Z]{3}$")
        private val CLOSED = byteArrayOf(0x69, 0x86.toByte())
    }

    private val worker = Executors.newSingleThreadExecutor()

    @Volatile
    private var selected = false

    override fun processCommandApdu(apdu: ByteArray, extras: Bundle?): ByteArray? {
        if (isSelect(apdu)) {
            selected = TapKeys.keyId(this) != null && TapKeys.privateKey() != null
            if (selected && !open() && !TapKeys.background(this)) {
                selected = false
                return CLOSED
            }
            return if (selected) "HAAT1".toByteArray(Charsets.UTF_8) + OK else NOT_SET_UP
        }
        if (!selected) return NOT_SET_UP
        if (apdu.size < 6 || apdu[0] != 0x80.toByte() || apdu[1] != 0x50.toByte()) return UNKNOWN

        val length = apdu[4].toInt() and 0xFF
        if (apdu.size < 5 + length) return REFUSED
        val data = apdu.copyOfRange(5, 5 + length)

        // Signing goes to the Keystore, which can be slow; the answer follows on its own.
        worker.execute { sendResponseApdu(pay(data)) }
        return null
    }

    override fun onDeactivated(reason: Int) {
        selected = false
    }

    private fun pay(data: ByteArray): ByteArray = try {
        val ask = JSONObject(String(data, Charsets.UTF_8))
        val code = ask.getString("c")
        val amount = ask.getString("a")
        val currency = ask.getString("cur")

        val confirm = ask.optBoolean("confirm")
        val keyId = TapKeys.keyId(this)
        val key = TapKeys.privateKey()
        if (!CODE.matches(code) || !AMOUNT.matches(amount) || !CURRENCY.matches(currency)) {
            REFUSED
        } else if (keyId == null || key == null) {
            if (confirm) {
                // Approved on this screen, so it can still pay; the merchant just
                // won't know who until it is paid.
                open("approve", code)
                JSONObject().put("confirm", true).toString().toByteArray(Charsets.UTF_8) + OK
            } else {
                NOT_SET_UP
            }
        } else {
            // Signed first, so the paying phone has its answer at once; then the app
            // opens, so this screen turns while the paying phone asks HAAT. With HAAT
            // closed or the phone locked it stays that way, and a notification tells.
            val signature = TapKeys.sign(key, TapKeys.message(code, amount, currency))
            if (open()) {
                open(if (confirm) "approve" else "tap", code)
            } else {
                TapNotice.follow(applicationContext, code)
            }
            JSONObject().put("k", keyId).put("s", signature).put("confirm", confirm).toString()
                .toByteArray(Charsets.UTF_8) + OK
        }
    } catch (_: Throwable) {
        REFUSED
    }

    /** HAAT is on screen, on an unlocked phone. */
    private fun open(): Boolean =
        TapKeys.foreground &&
            (getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager)
                ?.isKeyguardLocked != true

    /** The app, on the request: a receipt after a tap, its invoice to approve above the limit. */
    private fun open(kind: String, code: String) {
        try {
            startActivity(
                Intent(Intent.ACTION_VIEW, Uri.parse("haat://haat.com/$kind/$code"))
                    .setPackage(packageName)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            )
        } catch (_: Throwable) {
            // The payment does not depend on it; the merchant's phone shows the result.
        }
    }

    private fun isSelect(apdu: ByteArray): Boolean {
        if (apdu.size < 5 + TapKeys.AID.size) return false
        if (apdu[0] != 0x00.toByte() || apdu[1] != 0xA4.toByte() || apdu[2] != 0x04.toByte()) {
            return false
        }
        val length = apdu[4].toInt() and 0xFF
        return length == TapKeys.AID.size &&
            apdu.copyOfRange(5, 5 + length).contentEquals(TapKeys.AID)
    }
}

/**
 * What a tap answered with HAAT closed paid this phone, told in a notification.
 *
 * Nobody is signed in here — the session lives in Dart, behind the lock — so this phone
 * asks with its tap key instead: `POST /pay/{code}/tap-result`, signed over
 * `HAAT-TAP-RESULT-1|code`, answers only what that tap paid this phone's business. It
 * asks until the paying phone has paid, or a minute has passed.
 */
object TapNotice {
    private const val CHANNEL_ID = "haat.tap.received"
    private const val WAIT_MS = 60_000L
    private const val EVERY_MS = 1_500L

    /** Codes being followed; the paying phone may read this one twice for one tap. */
    private val following = ConcurrentHashMap.newKeySet<String>()

    fun follow(context: Context, code: String) {
        val base = TapKeys.apiBase(context) ?: return
        val key = TapKeys.privateKey() ?: return
        val keyId = TapKeys.keyId(context) ?: return
        val tap = code.uppercase()
        if (!following.add(tap)) return

        Thread {
            try {
                val body = JSONObject()
                    .put("keyId", keyId)
                    .put("signature", TapKeys.sign(key, TapKeys.resultMessage(tap)))
                    .toString()
                val until = SystemClock.elapsedRealtime() + WAIT_MS
                var result: JSONObject? = null
                while (SystemClock.elapsedRealtime() < until) {
                    result = ask(base, tap, body) ?: result
                    val status = result?.optString("status")
                    if (status != null && status != "pending") break
                    Thread.sleep(EVERY_MS)
                }
                notify(context, tap, result)
            } catch (_: Throwable) {
            } finally {
                following.remove(tap)
            }
        }.start()
    }

    /** HAAT's answer; null when it could not be reached, `unknown` when it refused. */
    private fun ask(base: String, code: String, body: String): JSONObject? {
        val connection = URL("$base/pay/$code/tap-result").openConnection() as HttpURLConnection
        return try {
            connection.requestMethod = "POST"
            connection.connectTimeout = 10_000
            connection.readTimeout = 10_000
            connection.doOutput = true
            connection.setRequestProperty("Content-Type", "application/json")
            connection.setRequestProperty("Accept", "application/json")
            connection.outputStream.use { it.write(body.toByteArray(Charsets.UTF_8)) }

            val status = connection.responseCode
            when {
                status in 200..299 -> {
                    val text = connection.inputStream.bufferedReader().use { it.readText() }
                    val json = JSONObject(text)
                    json.optJSONObject("data") ?: json
                }
                // Signed out, or a key HAAT no longer knows: asking again won't change it.
                status in 400..499 && status != 429 -> JSONObject().put("status", "unknown")
                else -> null
            }
        } catch (_: Throwable) {
            null
        } finally {
            connection.disconnect()
        }
    }

    private fun notify(context: Context, code: String, result: JSONObject?) {
        val notifications = NotificationManagerCompat.from(context)
        if (!notifications.areNotificationsEnabled()) return

        val currency = result?.optString("currency").orEmpty()
        val amount = money(result?.optString("amountMinor").orEmpty(), currency)
        val payer = result?.optString("payerName").orEmpty().ifBlank { "a HAAT business" }
        val (title, text) = when (result?.optString("status")) {
            "completed" -> "Payment received" to "$amount from $payer"
            "held" -> "Payment on hold" to
                "$amount from $payer is held for review. You'll be told when it's decided."
            "rejected" -> "Payment not received" to
                "$amount from $payer was turned down on review."
            "failed" -> "Payment not received" to "The tap from $payer didn't go through."
            else -> "Tap payment" to "Couldn't confirm the tap yet. Open HAAT to check."
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                .createNotificationChannel(
                    NotificationChannel(
                        CHANNEL_ID,
                        "Tap payments",
                        NotificationManager.IMPORTANCE_HIGH,
                    ).apply { description = "Payments received by tap with HAAT closed" },
                )
        }

        val receipt = PendingIntent.getActivity(
            context,
            code.hashCode(),
            Intent(Intent.ACTION_VIEW, Uri.parse("haat://haat.com/tap/$code"))
                .setPackage(context.packageName)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        fun base() = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.haat_tap_notification)
            .setContentIntent(receipt)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
            .setContentTitle(title)

        // On the lock screen, what happened but not how much or from whom.
        val notification = base()
            .setContentText(text)
            .setStyle(NotificationCompat.BigTextStyle().bigText(text))
            .setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
            .setPublicVersion(base().setContentText("Open HAAT for details").build())
            .build()

        try {
            notifications.notify(code.hashCode(), notification)
        } catch (_: SecurityException) {
            // Notifications refused since the check above; nothing else to tell with.
        }
    }

    /** `50000`, `SDG` → `500.00 SDG`. */
    private fun money(minor: String, currency: String): String {
        val digits = try {
            Currency.getInstance(currency).defaultFractionDigits.coerceAtLeast(0)
        } catch (_: Throwable) {
            2
        }
        return try {
            val format = DecimalFormat(if (digits == 0) "#,##0" else "#,##0." + "0".repeat(digits))
            "${format.format(BigDecimal(minor).movePointLeft(digits))} $currency".trim()
        } catch (_: Throwable) {
            "A payment"
        }
    }
}

/**
 * The paying half, and this phone's key setup, for Dart.
 *
 * `read` arms NFC reader mode and answers once: with the other phone's reply (a JSON
 * string), or an error code — `not_set_up` (that phone has no HAAT tap), `lost` (the
 * phones parted mid-read), `closed` (HAAT is closed there, and not paid while closed),
 * `refused`, `nfc_off`, `no_nfc`, `cancelled`. Reader mode
 * stays armed between reads so a phone held a moment early is not handed to another
 * app; `cancelRead` ends it.
 */
class TapBridge(private val activity: Activity) : MethodChannel.MethodCallHandler {
    companion object {
        const val CHANNEL = "com.mycompany.haat/tap"
    }

    private val main = Handler(Looper.getMainLooper())
    private val adapter: NfcAdapter? = NfcAdapter.getDefaultAdapter(activity)

    private var pending: MethodChannel.Result? = null

    @Volatile
    private var ask: JSONObject? = null

    private var armed = false

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "status" -> result.success(
                mapOf(
                    "reader" to (adapter != null),
                    "card" to activity.packageManager
                        .hasSystemFeature(PackageManager.FEATURE_NFC_HOST_CARD_EMULATION),
                    "enabled" to (adapter?.isEnabled == true),
                    "keyId" to (if (TapKeys.privateKey() != null) TapKeys.keyId(activity) else null),
                    "userId" to TapKeys.userId(activity),
                ),
            )
            "enrol" -> try {
                result.success(TapKeys.enrol(activity))
            } catch (error: Throwable) {
                result.error("key_unsupported", error.message ?: "No hardware key", null)
            }
            "save" -> {
                TapKeys.save(
                    activity,
                    call.argument<String>("keyId") ?: "",
                    call.argument<String>("userId") ?: "",
                )
                result.success(true)
            }
            "forget" -> {
                TapKeys.forget(activity)
                result.success(true)
            }
            // Paid by tap with the phone locked or HAAT closed: Security's switch.
            "background" -> result.success(
                mapOf(
                    "on" to TapKeys.background(activity),
                    "card" to activity.packageManager
                        .hasSystemFeature(PackageManager.FEATURE_NFC_HOST_CARD_EMULATION),
                    "screenOff" to (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S),
                    "notifications" to
                        NotificationManagerCompat.from(activity).areNotificationsEnabled(),
                ),
            )
            "setBackground" -> {
                val on = call.argument<Boolean>("on") ?: false
                TapKeys.setBackground(activity, on, call.argument<String>("apiBase"))
                if (on && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                    ContextCompat.checkSelfPermission(
                        activity,
                        Manifest.permission.POST_NOTIFICATIONS,
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    ActivityCompat.requestPermissions(
                        activity,
                        arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                        7301,
                    )
                }
                result.success(true)
            }
            "read" -> read(call, result)
            "cancelRead" -> {
                answer { it.error("cancelled", "Stopped", null) }
                ask = null
                armed = false
                try {
                    adapter?.disableReaderMode(activity)
                } catch (_: Throwable) {
                }
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun read(call: MethodCall, result: MethodChannel.Result) {
        val nfc = adapter ?: return result.error("no_nfc", "This phone has no NFC", null)
        if (!nfc.isEnabled) return result.error("nfc_off", "NFC is off", null)

        answer { it.error("cancelled", "Replaced", null) }
        ask = JSONObject()
            .put("c", call.argument<String>("code") ?: "")
            .put("a", call.argument<String>("amountMinor") ?: "")
            .put("cur", call.argument<String>("currency") ?: "")
            .put("confirm", call.argument<Boolean>("confirm") ?: false)
        synchronized(this) { pending = result }
        if (!armed) {
            armed = true
            resume()
        }
    }

    fun resume() {
        if (!armed) return
        try {
            adapter?.enableReaderMode(
                activity,
                { tag -> onTag(tag) },
                NfcAdapter.FLAG_READER_NFC_A or
                    NfcAdapter.FLAG_READER_NFC_B or
                    NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
                Bundle(),
            )
        } catch (_: Throwable) {
        }
    }

    /** On the NFC thread, so the reads here block nothing on screen. */
    private fun onTag(tag: Tag) {
        val asked = ask ?: return
        if (synchronized(this) { pending } == null) return
        val card = IsoDep.get(tag) ?: return

        try {
            card.connect()
            card.timeout = 5000

            val select = card.transceive(
                byteArrayOf(0x00, 0xA4.toByte(), 0x04, 0x00, TapKeys.AID.size.toByte()) +
                    TapKeys.AID + byteArrayOf(0x00),
            )
            if (status(select) == 0x6986) {
                answer { it.error("closed", "HAAT is closed on that phone", null) }
                return
            }
            if (!ok(select) || String(body(select), Charsets.UTF_8) != "HAAT1") {
                answer { it.error("not_set_up", "That phone has no HAAT tap", null) }
                return
            }

            val data = asked.toString().toByteArray(Charsets.UTF_8)
            val reply = card.transceive(
                byteArrayOf(0x80.toByte(), 0x50, 0x00, 0x00, data.size.toByte()) + data +
                    byteArrayOf(0x00),
            )
            if (!ok(reply)) {
                val code = if (status(reply) == 0x6A82) "not_set_up" else "refused"
                answer { it.error(code, "The phone refused", null) }
                return
            }
            val text = String(body(reply), Charsets.UTF_8)
            answer { it.success(text) }
        } catch (_: IOException) {
            answer { it.error("lost", "The phones moved apart", null) }
        } catch (_: Throwable) {
            answer { it.error("refused", "Could not read that phone", null) }
        } finally {
            try {
                card.close()
            } catch (_: Throwable) {
            }
        }
    }

    /** Replies to the waiting read, once; a second reply on a channel kills the engine. */
    private fun answer(reply: (MethodChannel.Result) -> Unit) {
        val result = synchronized(this) { pending.also { pending = null } } ?: return
        main.post { reply(result) }
    }

    private fun status(apdu: ByteArray): Int =
        if (apdu.size < 2) {
            0
        } else {
            ((apdu[apdu.size - 2].toInt() and 0xFF) shl 8) or (apdu[apdu.size - 1].toInt() and 0xFF)
        }

    private fun ok(apdu: ByteArray) = status(apdu) == 0x9000

    private fun body(apdu: ByteArray) = apdu.copyOfRange(0, maxOf(0, apdu.size - 2))
}
