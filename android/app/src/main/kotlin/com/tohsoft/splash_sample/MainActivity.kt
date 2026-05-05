package com.tohsoft.splash_sample

import UserNativeApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        UserNativeApi.setUp(flutterEngine.dartExecutor.binaryMessenger, UserApiImpl())
    }
}
