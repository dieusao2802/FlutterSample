package com.tohsoft.todo_list

import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Nhận log từ Dart side qua MethodChannel "app/native_log" và dispatch ra
 * `android.util.Log` theo level tương ứng để Logcat tô màu đúng.
 */
object AppLogChannel {
    private const val CHANNEL = "app/native_log"
    private const val DEFAULT_TAG = "AppLog"

    fun register(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method != "log") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val level = call.argument<String>("level") ?: "i"
                val tag = call.argument<String>("tag") ?: DEFAULT_TAG
                val message = call.argument<String>("message") ?: ""
                when (level) {
                    "v" -> Log.v(tag, message)
                    "d" -> Log.d(tag, message)
                    "i" -> Log.i(tag, message)
                    "w" -> Log.w(tag, message)
                    "e" -> Log.e(tag, message)
                    "f" -> Log.println(Log.ASSERT, tag, message)
                    else -> Log.i(tag, message)
                }
                result.success(null)
            }
    }
}
