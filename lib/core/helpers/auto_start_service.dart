import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

/// Service to handle auto-start permissions and background app management
/// This service helps ensure the app can run in the background to receive SMS
class AutoStartService {
  static final AutoStartService _instance = AutoStartService._internal();
  factory AutoStartService() => _instance;
  AutoStartService._internal();

  static const MethodChannel _methodChannel =
      MethodChannel('auto_start_service');

  /// Check if auto-start is enabled for the current app
  Future<bool> checkIsAutoStartEnabled() async {
    try {
      if (!Platform.isAndroid) {
        log('AutoStart: iOS does not require auto-start permissions');
        return true;
      }

      final bool? isEnabled =
          await _methodChannel.invokeMethod('checkIsAutoStartEnabled');
      final bool result = isEnabled ?? false;

      log('AutoStart: Is enabled = $result');
      return result;
    } on PlatformException catch (e) {
      log('AutoStart: Failed to check auto-start status: ${e.message}');
      return false;
    } catch (e) {
      log('AutoStart: Unexpected error checking auto-start: $e');
      return false;
    }
  }

  /// Request auto-start permission by opening device-specific settings
  Future<bool> requestAutoStartPermission() async {
    try {
      if (!Platform.isAndroid) {
        log('AutoStart: iOS does not require auto-start permissions');
        return true;
      }

      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final String manufacturer = androidInfo.manufacturer.toLowerCase();
      final String model = androidInfo.model.toLowerCase();

      log('AutoStart: Requesting permission for $manufacturer (model: $model)');

      return await _openAutoStartSettings(manufacturer, model);
    } catch (e) {
      log('AutoStart: Error requesting auto-start permission: $e');
      return false;
    }
  }

  /// Open auto-start settings for specific device manufacturers
  Future<bool> _openAutoStartSettings(String manufacturer, String model) async {
    try {
      if (manufacturer.contains('xiaomi') ||
          manufacturer.contains('redmi') ||
          model.contains('redmi')) {
        return await _openIntent('com.miui.securitycenter',
            'com.miui.permcenter.autostart.AutoStartManagementActivity');
      } else if (manufacturer.contains('oppo') ||
          manufacturer.contains('realme')) {
        return await _openIntent('com.coloros.safecenter',
            'com.coloros.safecenter.startupapp.StartupAppListActivity');
      } else if (manufacturer.contains('vivo') ||
          manufacturer.contains('iqoo')) {
        return await _openIntent('com.vivo.permissionmanager',
            'com.vivo.permissionmanager.activity.BgStartUpManagerActivity');
      } else if (manufacturer.contains('huawei') ||
          manufacturer.contains('honor')) {
        return await _openIntent('com.huawei.systemmanager',
            'com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity');
      } else if (manufacturer.contains('oneplus')) {
        return await _openIntent('com.oneplus.security',
            'com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity');
      } else if (manufacturer.contains('samsung')) {
        return await _openIntent('com.samsung.android.lool',
            'com.samsung.android.sm.ui.battery.BatteryActivity');
      } else if (manufacturer.contains('meizu')) {
        return await _openIntent(
            'com.meizu.safe', 'com.meizu.safe.security.SHOW_APPSEC');
      } else if (manufacturer.contains('asus')) {
        return await _openIntent('com.asus.mobilemanager',
            'com.asus.mobilemanager.autostart.AutoStartActivity');
      } else if (manufacturer.contains('letv') ||
          manufacturer.contains('leeco')) {
        return await _openIntent('com.letv.android.letvsafe',
            'com.letv.android.letvsafe.AutobootManageActivity');
      } else if (manufacturer.contains('lge') || manufacturer.contains('lg')) {
        return await _openIntent(
            'com.lge.launcher2', 'com.lge.launcher2.SettingsActivity');
      } else if (manufacturer.contains('htc')) {
        return await _openIntent('com.htc.pitroad',
            'com.htc.pitroad.landingpage.activity.LandingPageActivity');
      } else if (manufacturer.contains('lenovo')) {
        return await _openIntent('com.lenovo.security',
            'com.lenovo.security.purebackground.PureBackgroundActivity');
      } else if (manufacturer.contains('zte')) {
        return await _openIntent('com.zte.heartyservice',
            'com.zte.heartyservice.autorun.AppAutoRunManager');
      } else {
        log('AutoStart: No specific auto-start settings found for $manufacturer');
        return await _openGeneralSettings();
      }
    } catch (e) {
      log('AutoStart: Failed to open auto-start settings: $e');
      return false;
    }
  }

  /// Open specific app intent for auto-start settings
  Future<bool> _openIntent(String packageName, String className) async {
    try {
      final bool? result = await _methodChannel.invokeMethod('openIntent', {
        'packageName': packageName,
        'className': className,
      });

      if (result == true) {
        log('AutoStart: Successfully opened $packageName/$className');
        return true;
      } else {
        log('AutoStart: Failed to open $packageName/$className, trying fallback');
        return await _openGeneralSettings();
      }
    } catch (e) {
      log('AutoStart: Error opening intent $packageName/$className: $e');
      return await _openGeneralSettings();
    }
  }

  /// Open general app settings as fallback
  Future<bool> _openGeneralSettings() async {
    try {
      final bool? result = await _methodChannel.invokeMethod('openAppSettings');
      log('AutoStart: Opened general app settings: ${result ?? false}');
      return result ?? false;
    } catch (e) {
      log('AutoStart: Failed to open general app settings: $e');
      return false;
    }
  }

  /// Get user-friendly instructions for enabling auto-start
  Future<String> getAutoStartInstructions() async {
    try {
      if (!Platform.isAndroid) {
        return 'iOS apps run in the background automatically.';
      }

      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final String manufacturer = androidInfo.manufacturer.toLowerCase();

      if (manufacturer.contains('xiaomi') || manufacturer.contains('redmi')) {
        return 'Go to Security > Autostart > Enable for this app';
      } else if (manufacturer.contains('oppo') ||
          manufacturer.contains('realme')) {
        return 'Go to Settings > Battery > App Auto-Start Management > Enable for this app';
      } else if (manufacturer.contains('vivo')) {
        return 'Go to Settings > Battery > Background App Refresh > Enable for this app';
      } else if (manufacturer.contains('huawei') ||
          manufacturer.contains('honor')) {
        return 'Go to Phone Manager > Auto-launch > Enable for this app';
      } else if (manufacturer.contains('oneplus')) {
        return 'Go to Settings > Battery > Battery Optimization > Don\'t optimize this app';
      } else if (manufacturer.contains('samsung')) {
        return 'Go to Settings > Battery > App Power Management > Apps that won\'t be put to sleep';
      } else {
        return 'Go to Settings > Apps > Special app access > Battery optimization > Don\'t optimize this app';
      }
    } catch (e) {
      return 'Please enable auto-start or disable battery optimization for this app in your device settings.';
    }
  }

  /// Check if the device needs auto-start configuration
  Future<bool> needsAutoStartConfiguration() async {
    if (!Platform.isAndroid) return false;

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final String manufacturer = androidInfo.manufacturer.toLowerCase();

      // Devices that typically need auto-start configuration
      const needsConfiguration = [
        'xiaomi',
        'redmi',
        'oppo',
        'realme',
        'vivo',
        'iqoo',
        'huawei',
        'honor',
        'oneplus',
        'meizu',
        'asus',
        'letv',
        'leeco'
      ];

      return needsConfiguration.any((brand) => manufacturer.contains(brand));
    } catch (e) {
      log('AutoStart: Error checking if device needs configuration: $e');
      return true; // Assume configuration is needed if we can't determine
    }
  }

  /// Initialize auto-start service and check current status
  Future<Map<String, dynamic>> initialize() async {
    try {
      final bool isEnabled = await checkIsAutoStartEnabled();
      final bool needsConfig = await needsAutoStartConfiguration();
      final String instructions = await getAutoStartInstructions();

      final result = {
        'isEnabled': isEnabled,
        'needsConfiguration': needsConfig,
        'instructions': instructions,
        'canRequestPermission': Platform.isAndroid,
      };

      log('AutoStart: Initialization complete - $result');
      return result;
    } catch (e) {
      log('AutoStart: Initialization failed: $e');
      return {
        'isEnabled': false,
        'needsConfiguration': true,
        'instructions': 'Please enable auto-start in device settings',
        'canRequestPermission': Platform.isAndroid,
        'error': e.toString(),
      };
    }
  }
}
