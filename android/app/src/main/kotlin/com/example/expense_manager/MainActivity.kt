package com.example.expense_manager

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity : FlutterActivity(), MethodCallHandler {
    private val CHANNEL = "auto_start_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "checkIsAutoStartEnabled" -> {
                result.success(checkAutoStartStatus())
            }
            "openIntent" -> {
                val packageName = call.argument<String>("packageName")
                val className = call.argument<String>("className")
                if (packageName != null && className != null) {
                    result.success(openSpecificIntent(packageName, className))
                } else {
                    result.success(false)
                }
            }
            "openAppSettings" -> {
                result.success(openAppSettings())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun checkAutoStartStatus(): Boolean {
        return try {
            val manufacturer = Build.MANUFACTURER.lowercase()
            val model = Build.MODEL.lowercase()
            
            // For most manufacturers, we cannot programmatically check if auto-start is actually enabled
            // Instead, we return false for devices that typically require manual auto-start configuration
            // This encourages users to check and enable auto-start manually
            when {
                manufacturer.contains("xiaomi") || manufacturer.contains("redmi") || model.contains("redmi") -> {
                    // MIUI devices typically require manual auto-start configuration
                    false
                }
                manufacturer.contains("oppo") || manufacturer.contains("realme") -> {
                    // ColorOS devices typically require manual auto-start configuration
                    false
                }
                manufacturer.contains("vivo") || manufacturer.contains("iqoo") -> {
                    // FuntouchOS devices typically require manual auto-start configuration
                    false
                }
                manufacturer.contains("huawei") || manufacturer.contains("honor") -> {
                    // EMUI devices typically require manual auto-start configuration
                    false
                }
                manufacturer.contains("oneplus") -> {
                    // OxygenOS devices typically require manual auto-start configuration
                    false
                }
                manufacturer.contains("meizu") -> {
                    // Flyme devices typically require manual auto-start configuration
                    false
                }
                manufacturer.contains("samsung") -> {
                    // Samsung devices generally don't restrict auto-start as aggressively
                    true
                }
                manufacturer.contains("google") || manufacturer.contains("pixel") -> {
                    // Stock Android devices typically don't restrict auto-start
                    true
                }
                else -> {
                    // For unknown manufacturers, assume auto-start might be restricted
                    // Better to prompt user to check manually
                    false
                }
            }
        } catch (e: Exception) {
            // If we can't determine, assume auto-start needs to be checked manually
            false
        }
    }

    private fun openSpecificIntent(packageName: String, className: String): Boolean {
        return try {
            val intent = Intent().apply {
                component = ComponentName(packageName, className)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }

    private fun openAppSettings(): Boolean {
        return try {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.fromParts("package", packageName, null)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }
}
