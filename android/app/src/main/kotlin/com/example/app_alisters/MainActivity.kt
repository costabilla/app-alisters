package com.example.app_alisters

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "alisters/storage").setMethodCallHandler { call, result ->
            val prefs = getSharedPreferences("alisters", MODE_PRIVATE)
            when (call.method) {
                "read" -> result.success(prefs.getString("entries", null))
                "write" -> {
                    val value = call.arguments as? String
                    if (value == null) result.error("invalid", "Dados inválidos", null)
                    else if (prefs.edit().putString("entries", value).commit()) result.success(null)
                    else result.error("storage", "Falha ao salvar", null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
