import UIKit
import Flutter
import Foundation
import LocalAuthentication
import Security

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // The Secure Enclave key behind biometric sign-in. Registered here rather than as a
    // plugin because it is one file that belongs to this app, not something to publish.
    if let controller = window?.rootViewController as? FlutterViewController {
      BiometricKeyBridge.register(with: controller.binaryMessenger)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// ---------------------------------------------------------------------------
// BiometricKeyBridge lived in its own file, ios/Runner/BiometricKeyBridge.swift.
// FlutterFlow exposes only four iOS files — Info.plist, Runner.entitlements,
// AppDelegate.swift and the Podfile — and there is no way to add a fifth, so the
// class is inlined here. Swift is happy with several types in one file; without
// this the AppDelegate above fails to build with "Cannot find 'BiometricKeyBridge'
// in scope".
// ---------------------------------------------------------------------------


/// The iOS half of biometric sign-in — the counterpart to `BiometricKeyBridge.kt`.
///
/// Same bargain as on Android: the backend stores the public half of a P-256 pair and
/// later checks an ECDSA signature over a challenge it issued, and that is only worth
/// something if the private half cannot be read. Here it lives in the Secure Enclave,
/// created with an access control of `.biometryCurrentSet`, so the key is destroyed the
/// moment the enrolled Face ID or Touch ID changes — somebody who adds their own face to
/// an unlocked phone gets a key that no longer signs, not one that now signs for them.
///
/// Two details differ from Android and both matter:
///
///  - `SecKeyCopyExternalRepresentation` returns the **raw X9.63 point**, not the SPKI
///    the server parses, so [subjectPublicKeyInfo] puts the ASN.1 header back on.
///  - Using the key is what raises the prompt; there is no separate authenticate step.
///    The call blocks while the sheet is up, so it runs off the main thread.
///
/// **Not yet built or run.** It was written against the same contract the Android side
/// was tested against, but no Mac was available — treat it as unverified until it has
/// been through Xcode and a real handset.
final class BiometricKeyBridge {
    static let channelName = "com.mycompany.haat/biometric_key"

    /// Codes the Dart side switches on. Must match `BiometricKeyStore._reason`.
    private static let errorNoHardware = "no_hardware"
    private static let errorNotEnrolled = "not_enrolled"
    private static let errorCancelled = "cancelled"
    private static let errorKeyUnsupported = "key_unsupported"
    private static let errorKeyInvalidated = "key_invalidated"
    private static let errorPlatform = "platform_error"

    private static let keyTag = "com.mycompany.haat.biometric.signing"
        .data(using: .utf8)!

    static func register(with messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        let bridge = BiometricKeyBridge()

        channel.setMethodCallHandler { call, result in
            bridge.handle(call, result: result)
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "hasKey":
            result(loadPrivateKey(context: nil) != nil)
        case "availability":
            result(availability())
        case "enrol":
            enrol(result: result)
        case "sign":
            let arguments = call.arguments as? [String: Any] ?? [:]
            guard let challenge = arguments["challenge"] as? String,
                  !challenge.isEmpty
            else {
                result(FlutterError(
                    code: Self.errorPlatform,
                    message: "A challenge is required",
                    details: nil
                ))
                return
            }

            sign(
                challenge: challenge,
                reason: arguments["reason"] as? String ?? "Sign in to HAAT",
                cancel: arguments["negative"] as? String ?? "Cancel",
                result: result
            )
        case "remove":
            deleteKey()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Nil when biometrics are usable, otherwise the reason they are not.
    private func availability() -> String? {
        var error: NSError?
        let context = LAContext()

        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) {
            return nil
        }

        switch error.map({ LAError.Code(rawValue: $0.code) }) ?? nil {
        case .biometryNotEnrolled:
            return Self.errorNotEnrolled
        case .biometryNotAvailable, .passcodeNotSet:
            return Self.errorNoHardware
        default:
            return Self.errorPlatform
        }
    }

    private func enrol(result: @escaping FlutterResult) {
        if let unavailable = availability() {
            result(FlutterError(
                code: unavailable,
                message: "Biometrics are not available",
                details: nil
            ))
            return
        }

        // One enrolment per device. A leftover key would keep signing for a public half
        // the server has since replaced, which reads as a rejected signature with no way
        // for anyone to see why.
        deleteKey()

        var accessError: Unmanaged<CFError>?
        guard let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            // Bound to this device and to a passcode being set: without a passcode there
            // is no Secure Enclave protection worth relying on.
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            [.privateKeyUsage, .biometryCurrentSet],
            &accessError
        ) else {
            result(FlutterError(
                code: Self.errorKeyUnsupported,
                message: describe(accessError),
                details: nil
            ))
            return
        }

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            // Absent on the simulator, which has no enclave — the failure below is the
            // correct answer there rather than something to work around.
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: Self.keyTag,
                kSecAttrAccessControl as String: access,
            ],
        ]

        var keyError: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(
            attributes as CFDictionary,
            &keyError
        ) else {
            result(FlutterError(
                code: Self.errorKeyUnsupported,
                message: describe(keyError),
                details: nil
            ))
            return
        }

        var exportError: Unmanaged<CFError>?
        guard let publicKey = SecKeyCopyPublicKey(privateKey),
              let point = SecKeyCopyExternalRepresentation(
                  publicKey,
                  &exportError
              ) as Data?
        else {
            result(FlutterError(
                code: Self.errorPlatform,
                message: describe(exportError),
                details: nil
            ))
            return
        }

        result(subjectPublicKeyInfo(from: point).base64EncodedString())
    }

    private func sign(
        challenge: String,
        reason: String,
        cancel: String,
        result: @escaping FlutterResult
    ) {
        let context = LAContext()
        context.localizedReason = reason
        context.localizedCancelTitle = cancel

        // Loading the key and signing both block while the sheet is up, so neither may
        // happen on the main thread — and every reply has to come back to it.
        DispatchQueue.global(qos: .userInitiated).async {
            func reply(_ value: Any?) {
                DispatchQueue.main.async { result(value) }
            }

            guard let privateKey = self.loadPrivateKey(context: context) else {
                reply(FlutterError(
                    code: Self.errorKeyUnsupported,
                    message: "No device key is enrolled",
                    details: nil
                ))
                return
            }

            var signError: Unmanaged<CFError>?
            // Signed as the bytes of the string the server sent. The server verifies the
            // same way, so neither side may decode the hex into bytes first.
            let payload = Data(challenge.utf8)

            guard let signature = SecKeyCreateSignature(
                privateKey,
                .ecdsaSignatureMessageX962SHA256,
                payload as CFData,
                &signError
            ) as Data? else {
                let failure = signError?.takeRetainedValue()

                reply(FlutterError(
                    code: self.code(for: failure),
                    message: failure.map { CFErrorCopyDescription($0) as String }
                        ?? "Could not sign",
                    details: nil
                ))
                return
            }

            reply(signature.base64EncodedString())
        }
    }

    private func loadPrivateKey(context: LAContext?) -> SecKey? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: Self.keyTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true,
        ]

        if let context {
            query[kSecUseAuthenticationContext as String] = context
        } else {
            // Asking only whether a key exists must not raise a prompt, which is what
            // this suppresses — `hasKey` is called to decide whether to offer the option.
            query[kSecUseAuthenticationUI as String] = kSecUseAuthenticationUIFail
        }

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        // errSecInteractionNotAllowed means the key is there and would need a prompt,
        // which for `hasKey` is a yes.
        guard status == errSecSuccess || status == errSecInteractionNotAllowed,
              let key = item
        else {
            return nil
        }

        return (key as! SecKey)
    }

    private func deleteKey() {
        SecItemDelete([
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: Self.keyTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        ] as CFDictionary)
    }

    /// Which of the Dart-side reasons a signing failure amounts to.
    private func code(for error: CFError?) -> String {
        guard let error else { return Self.errorPlatform }

        switch CFErrorGetCode(error) {
        case Int(errSecUserCanceled), LAError.userCancel.rawValue,
             LAError.systemCancel.rawValue, LAError.appCancel.rawValue:
            return Self.errorCancelled
        case Int(errSecItemNotFound), LAError.invalidContext.rawValue:
            // The enrolled biometrics changed, so `.biometryCurrentSet` destroyed the
            // key. Nothing is broken — the owner enrols again.
            return Self.errorKeyInvalidated
        case LAError.biometryNotEnrolled.rawValue:
            return Self.errorNotEnrolled
        case LAError.biometryNotAvailable.rawValue:
            return Self.errorNoHardware
        default:
            return Self.errorPlatform
        }
    }

    private func describe(_ error: Unmanaged<CFError>?) -> String {
        guard let error else { return "Unknown error" }

        return CFErrorCopyDescription(error.takeRetainedValue()) as String
    }

    /// Wraps a raw X9.63 point as the SPKI the backend parses.
    ///
    /// `SecKeyCopyExternalRepresentation` hands back `04 || X || Y` and nothing else,
    /// while `POST /auth/biometric` reads SubjectPublicKeyInfo — so the fixed ASN.1
    /// header for `id-ecPublicKey` over `prime256v1` goes back on the front. It is
    /// constant for P-256, which is the only curve either side accepts.
    private func subjectPublicKeyInfo(from point: Data) -> Data {
        let header: [UInt8] = [
            0x30, 0x59, // SEQUENCE, 89 bytes
            0x30, 0x13, // SEQUENCE, 19 bytes
            0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01, // id-ecPublicKey
            0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07, // prime256v1
            0x03, 0x42, 0x00, // BIT STRING, 66 bytes, no unused bits
        ]

        return Data(header) + point
    }
}
