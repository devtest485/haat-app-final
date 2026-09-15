package com.mycompany.haat

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * A [FlutterFragmentActivity], not a `FlutterActivity`.
 *
 * `BiometricPrompt` is a fragment and needs a `FragmentActivity` to attach to; so does
 * `local_auth`. On a plain `FlutterActivity` both fail at the moment the prompt is shown,
 * which is the worst place to find out.
 */
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BiometricKeyBridge.CHANNEL,
        ).setMethodCallHandler(BiometricKeyBridge(this))
    }
}
