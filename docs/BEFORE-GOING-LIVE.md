# Before going live

Things that are deliberately unfinished or deliberately loosened for development, and
have to be dealt with before a build reaches a merchant. Each entry says what it is,
where it lives, how to check it, and what "done" means.

Nothing here is a surprise waiting to be discovered — it is written down because it was
a decision, not an oversight.

---

## 1. The one-time code is filled in for you

**Status:** development convenience, on now.

In a debug build against a non-production backend, the six OTP boxes arrive already
filled. The backend returns the code in `devOtpCode` so the sign-up flow can be walked
through without an SMS gateway, and the app puts it in the boxes instead of making
somebody read it out of a log.

**It is not a bypass.** The digits are still sent to `POST /auth/verify-otp` and still
verified by the server. The path exercised in development is the path that runs in
production — which is the whole reason it was done this way rather than by accepting a
fixed code like `000000`, which would have been a real hole to remember to close.

Two independent conditions have to hold for it to happen:

| Condition | Where |
| --- | --- |
| The build is a debug build | `kDebugMode` in [`otp_verify_page_widget.dart`](../lib/auth_flow/otp_verify_page/otp_verify_page_widget.dart) — `_devCode` |
| The server chose to send the code | `devOtpCode` is null outside development, so [`AuthSession.devOtpCode`](../lib/backend/auth/auth_session.dart) stays null |

A release build cannot show it even if a server were misconfigured to send one, and a
debug build against production has nothing to show.

The screen says **"Development build: code filled in automatically."** underneath the
boxes whenever it happens, so nobody mistakes the shortcut for the feature working.

**Before going live**

- [ ] The backend must have an **SMS provider** configured. Until an `OUTBOX_DISPATCHER`
      is supplied, `POST /auth/register` records the code and nothing sends it — the
      relay says so loudly at startup. This is the item that actually blocks launch;
      without it nobody outside development can register at all.
- [ ] Confirm the production backend returns `devOtpCode: null`. Register once against
      it and read the response.
- [ ] Build a release APK and confirm the boxes come up empty and the yellow line is
      absent.

---

## 2. Biometric sign-in is not implemented

**Status:** deliberately incomplete, and honest about it.

`POST /auth/biometric` expects the public half of a P-256 key pair generated **inside
the phone's secure hardware**, and verification expects an ES256 signature over a
server-issued challenge. `local_auth` cannot do that — it shows the system prompt and
reports a boolean, and a boolean crossing a platform channel proves nothing to a server.

So [`biometric_key_store.dart`](../lib/backend/auth/biometric_key_store.dart) reports
that it cannot enrol, and says why on screen. It deliberately **does not** generate a key
in Dart and send that: a private key in the app's own storage can be copied off a rooted
device, which removes the entire reason the endpoint is designed this way while looking
finished.

Nothing is blocked meanwhile — the screen offers **Skip**, and the passcode works.

**Before going live**

- [ ] Write the platform channel:
      - **Android** — `KeyPairGenerator.getInstance("EC", "AndroidKeyStore")` with a
        `KeyGenParameterSpec` setting `setUserAuthenticationRequired(true)`,
        `setDigests(DIGEST_SHA256)` and P-256; sign with
        `Signature.getInstance("SHA256withECDSA")`.
      - **iOS** — `SecKeyCreateRandomKey` with `kSecAttrTokenIDSecureEnclave` and an
        access control of `biometryCurrentSet`; sign with `SecKeyCreateSignature` and
        `ecdsaSignatureMessageX962SHA256`.
- [ ] Both return the SPKI public key on enrolment and a base64 signature per sign-in,
      which is what the two endpoints already accept — no backend change needed.
- [ ] Add the four biometric routes to the Postman collection; they are currently the
      largest untested area of the API.

---

## 3. Plaintext HTTP is permitted, for one address

**Status:** debug builds only.

Android has refused cleartext HTTP since API 28.
[`network_security_config.xml`](../android/app/src/debug/res/xml/network_security_config.xml)
permits it for the development machine and nowhere else, and lives under `src/debug` so
a release build keeps the platform default.

The tempting one-liner — `android:usesCleartextTraffic="true"` in the main manifest —
would ship that permission to production and allow plaintext to any host on the
internet. It is not used.

**Before going live**

- [ ] `apiBaseUrl` in
      [`environment.json`](../assets/environment_values/environment.json) must be
      **https**, pointing at the production gateway. It currently holds a LAN address.
- [ ] Confirm the release manifest carries no `networkSecurityConfig` and no
      `usesCleartextTraffic`:
      ```bash
      flutter build apk --release
      # then inspect the merged manifest
      unzip -p build/app/outputs/flutter-apk/app-release.apk AndroidManifest.xml | strings | grep -i cleartext
      ```
- [ ] Consider certificate pinning for the gateway. Worth a decision, not obviously
      worth doing — it complicates certificate rotation.

---

## 4. The typeface is downloaded at runtime

**Status:** unintended, and worth fixing.

Every screen asks for its font with `GoogleFonts.inter(...)`, and `assets/fonts/`
contains only `Roboto-Regular.ttf` with no `fonts:` section in `pubspec.yaml`. So the
app fetches Inter over the network on first launch.

That means a merchant on a slow or absent connection sees the app in a fallback face,
and every install pays for a download that could have shipped in the APK. It also makes
host-side layout tests useless, which is why the layout audit has to run on a device.

**Before going live**

- [ ] Download the Inter and Inter Tight weights the app actually uses, put them in
      `assets/fonts/`, and declare them under `fonts:` in `pubspec.yaml`. `google_fonts`
      then uses the bundled files and stops reaching for the network.
- [ ] Re-run the layout audit afterwards; bundled metrics are the real ones, so the
      numbers may move.

---

## 5. One layout finding is unresolved

**Status:** open, cause not established.

[`integration_test/layout_test.dart`](../integration_test/layout_test.dart) reports one
remaining problem, on the one-time-code screen:

```
OtpVerifyPage
    RenderBox was not laid out: RenderEditable … NEEDS-LAYOUT DETACHED
```

Two real bugs found while chasing it **are** fixed: a `FocusNode` built inside `build`
(a new node per keystroke, none disposed) and a `FocusScope.of(context)` read after an
`await`. Neither removed this.

It reproduces only under the test driver, where `enterText` drives six fields
synchronously and also raises "setState called during build" — which is a property of
the driver, not of a person typing. Typing the code by hand on the device did not
produce it.

**Before going live**

- [ ] Watch the console while typing a code on a device. If it appears there, it is
      real and worth chasing; if it never does, close the finding and note the driver
      as the cause.
- [ ] Do not silence it in the test to make the suite green. A guard added to hide it
      would remove the only signal there is.

---

## 6. The development database cannot take concurrent requests

**Status:** a property of the local setup, not a bug to fix.

The backend's no-Docker path runs PGlite, which serves one connection at a time.
Several simultaneous requests fail there for reasons that have nothing to do with the
app, so tests that need concurrency count what they are measuring directly instead of
inferring it from whether calls succeeded.

Not a launch blocker — production is PostgreSQL — but worth knowing before believing a
local failure.
