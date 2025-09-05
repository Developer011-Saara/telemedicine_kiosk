package com.example.telemedicine_kiosk

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val kioskModeChannel = "kioskModeLocked"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, kioskModeChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "startKioskMode") {
                    startLockTask()
                    result.success(null)
                } else if (call.method == "stopKioskMode") {
                    stopLockTask()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
