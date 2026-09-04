# HAAT

The merchant app for HAAT, Syber Technology's payment acceptance platform. The screens
are FlutterFlow-generated; the backend integration under [`lib/backend/`](lib/backend/)
is hand-written.

> **Read [docs/BEFORE-GOING-LIVE.md](docs/BEFORE-GOING-LIVE.md) before shipping.** Six
> things are deliberately unfinished or loosened for development — the one-time code is
> filled in for you, biometrics are not implemented, plaintext HTTP is allowed to one
> address, and the typeface is downloaded at runtime. Each is written down with how to
> check it and what "done" means.

## Getting started

FlutterFlow projects run on the Flutter _stable_ release.

```bash
flutter pub get
flutter run
```

## Talking to the backend

### Where the API is

The base URL is read once at startup from
[`assets/environment_values/environment.json`](assets/environment_values/environment.json):

```json
{ "apiBaseUrl": "http://192.168.1.20:3000/api/v1" }
```

With no `apiBaseUrl` set, a per-platform development default applies — and `localhost`
is deliberately **not** it, because each platform reaches the developer's machine by a
different name:

| Running on | Reaches the host as |
| --- | --- |
| Android emulator | `10.0.2.2` — `localhost` is the emulated handset, where nothing is listening |
| iOS simulator | `localhost`, which shares the host's network stack |
| A real device | the machine's LAN address, which no default can guess — set `apiBaseUrl` |

Getting this wrong is the most common way a first run appears to hang rather than fail.

### The response envelope

Every reply from the backend, successful or not, has one shape:

```json
{
  "isSuccess": true,
  "title": "Verification Sent",     "title_ar": "تم إرسال رمز التحقق",
  "message": "Enter the code…",     "message_ar": "أدخل الرمز…",
  "data": { },
  "responseCode": 201,
  "requestId": "1f53b0c3-…"
}
```

The title and message are written for a person and already come in both languages, so
**screens show what the server said** rather than composing their own wording. Error
text then lives in one place and is translated once — the alternative is the same
sentence maintained in two repositories, with the Arabic wrong in one of them.

[`api_feedback.dart`](lib/backend/ui/api_feedback.dart) is how that reaches the user, so
failures look the same wherever they happen.

### Three outcomes, not two

[`ApiResult`](lib/backend/api/api_result.dart) is a sealed type with three cases,
because a screen that only checks a boolean cannot tell the last two apart:

| | Means | What the screen does |
| --- | --- | --- |
| `ApiSuccess` | The server said yes | Carry on |
| `ApiFailure` | The server said no, and why | Show its message; usually the input needs fixing |
| `ApiUnreachable` | The server was never reached | Show wording the app supplies — there is no server message |

Only `ApiUnreachable` means "try again". Collapsing it into failure produces the classic
"An error occurred" on a train.

### What the client does so screens do not have to

[`ApiClient`](lib/backend/api/api_client.dart):

- attaches the bearer token;
- puts an `Idempotency-Key` on every write, so a request the server carried out but
  never acknowledged is not carried out twice;
- refreshes an expired access token **once** and retries the call, transparently;
- returns every failure as a value rather than throwing.

The refresh is single-flight, and that is not a micro-optimisation. The backend rotates
the refresh token on every use, so three calls failing at once with three separate
refreshes means two of them present a token the first already spent — and the user is
signed out by the mechanism meant to keep them signed in. There is
[a test that counts the refreshes](test/backend/auth_flow_test.dart).

### Where the tokens live

The platform keystore — Android Keystore, iOS Keychain — via
[`TokenStore`](lib/backend/auth/token_store.dart), not `SharedPreferences`. A refresh
token is a long-lived credential that mints access tokens, and preferences are a plain
file: readable on a rooted handset and swept up by some backup tools.

Every keystore call is guarded, because the plugin does throw in the field — a corrupted
entry after an OS upgrade is the usual cause — and a storage failure has to degrade to
"signed out", never to a crash on launch.

## The flows

### Signing up

```
onboarding ─► phone ─► code ─► password ─► passcode ─► biometrics ─► handle
                │        │         │           │            │           │
            register  verify   /password   /passcode   /biometric   /username
```

Each screen waits for the backend before moving on. That sounds obvious and was the main
thing missing: the generated screens navigated on tap regardless, so somebody could
reach the code screen with no code on its way, or "set" a passcode the server never
received.

Two details worth knowing:

- Against a non-production backend, `register` returns the one-time code in
  `devOtpCode`, and a debug build **fills the six boxes with it** so nobody has to read
  a code out of a log. It bypasses nothing — the digits still go to
  `POST /auth/verify-otp` and are still verified — and it needs two independent
  conditions: a debug build *and* a server that chose to send the code. The screen says
  so underneath the boxes whenever it happens. See
  [before going live](docs/BEFORE-GOING-LIVE.md#1-the-one-time-code-is-filled-in-for-you).
- The countdown on the code screen was never started, which left the label frozen and
  resending unreachable. It now runs, and offers **Resend code** when it reaches zero.

### Signing in

There were no sign-in screens at all — the app could be installed once and never
returned to. [`sign_in_page`](lib/auth_flow/sign_in_page/) follows the sign-up screens'
language rather than introducing a second look, and handles the three answers besides
yes and no:

| The server says | The screen does |
| --- | --- |
| A second factor is owed | Becomes a code prompt, in place — the user is not sent to a route they cannot go back from |
| The account is locked | Counts down on the button instead of inviting an attempt certain to fail |
| An employer chose this password | Sends the user to replace it before anything else |

Both identifiers work: a merchant registered with a phone number, and an
employer-created staff account has no phone number on file — only the handle it was
given. The backend refuses a request naming two, so the screen picks one.

## Biometrics are not finished

[`biometric_key_store.dart`](lib/backend/auth/biometric_key_store.dart) says what is
missing and why, and it is worth reading before assuming this works.

`POST /auth/biometric` wants the public half of a P-256 pair generated **inside the
phone's secure hardware**, and verification wants an ES256 signature over a server
challenge. `local_auth` cannot do that: it shows the system prompt and reports a boolean,
and a boolean crossing a platform channel proves nothing to a server.

So availability and the prompt work, and enrolment reports honestly that it cannot
proceed. It deliberately **does not** generate a key in Dart and send that — a private
key in the app's own storage can be copied off a rooted device, which removes the whole
reason the endpoint is designed this way, while looking finished.

Finishing it is a platform channel: `AndroidKeyStore` with
`setUserAuthenticationRequired(true)` on Android, `kSecAttrTokenIDSecureEnclave` on iOS.
Both return exactly what the two endpoints already accept. The screen offers **Skip** and
the passcode still works, so nothing is blocked meanwhile.

## Running on a real device

Three things have to line up, and each one fails in a way that looks like a bug in the
app.

**1. Point the app at the machine, not at the phone.** In
[environment.json](assets/environment_values/environment.json):

```json
{ "apiBaseUrl": "http://192.168.18.4:3000/api/v1" }
```

`localhost` is the handset itself and `10.0.2.2` is the emulator's route to its host, so
on real hardware neither reaches your machine. Check it from the phone before blaming
the app:

```bash
adb shell curl -s http://<your-lan-ip>:3000/health/ready
```

**2. Android blocks plaintext HTTP.** Since API 28 a request to `http://` is refused
before it leaves the device. [A debug-only network security
config](android/app/src/debug/res/xml/network_security_config.xml) permits it for the
development machine and nowhere else — it lives under `src/debug`, so a release build
keeps the platform default. Add your address there when it changes.

The tempting one-liner — `android:usesCleartextTraffic="true"` in the main manifest —
would ship that permission to production and allow plaintext to any host on the
internet.

**3. Install the app, not the test harness.** `flutter test integration_test/...`
installs an APK whose entrypoint is the *test*, so launching it from the home screen
shows a white screen forever. `flutter build apk --debug` builds the app.

## Tests

```bash
flutter test                                                  # host tests
flutter test integration_test/layout_test.dart    -d <device>  # layout, on hardware
flutter test integration_test/auth_flow_test.dart -d <device>  # the screens, with a keyboard
```

### Layout has to be checked on a device

[`integration_test/layout_test.dart`](integration_test/layout_test.dart) boots the app,
visits all 33 routes and reports overflow. It has to run on hardware, and it took three
attempts to produce answers worth acting on:

| Attempt | What it said | Why it was wrong |
| --- | --- | --- |
| Host `flutter test`, each page in its own `MaterialApp` | 40 broken pages, one "overflowed by 99471 pixels" | No Inter to measure with — the app fetches its font at runtime and bundles none — and a page wrapped in a different tree gets different constraints |
| On device, own `MaterialApp` | 40 pages | Still the wrong tree |
| On device, driving the app's own router | **3 pages** | Right font, right constraints, right insets |

Two of those three are fixed. The keyboard pass raises the real keyboard by tapping a
field, because faking `viewInsets` on the test view does nothing once the app is built —
it reported every page clean, for no reason at all.

One more trap: `app.main()` can only be called **once** per run. A second call stacks a
second app over the first and the router's `GlobalKey` collides, so everything after the
first test fails for a reason that has nothing to do with the app.

[`test/backend/auth_flow_test.dart`](test/backend/auth_flow_test.dart) talks to a running
gateway rather than a mock. The thing worth checking is whether the field a screen reads
exists in the real response, and a mock would only prove the app agrees with itself —
while the mistake it hides produces a screen that looks right and shows nothing.

It needs the backend up, and fails with that instruction when it is not. A silent skip
would report green for a suite that checked nothing.

Two notes for anyone extending it:

- `TestWidgetsFlutterBinding` installs an `HttpOverrides` that answers **every** request
  with an empty `400`, so a test cannot reach the network by accident. Reaching it is the
  point here, so the file clears it. Without that, everything fails with "the server sent
  a reply we could not read", which looks like a parsing bug and is not one.
- The development database is PGlite, which serves one connection at a time. Several
  simultaneous requests can fail there for reasons that have nothing to do with the app,
  so the concurrency test counts refreshes directly instead of inferring them from
  whether the calls succeeded.
