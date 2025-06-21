import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> isSmsPermissionGranted() async {
    final status = await Permission.sms.status;
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  /// Checks and requests SMS permission if not already granted.
  /// Returns `true` if permission is granted, `false` otherwise.
  static Future<bool> askSmsPermission() async {
    final status = await Permission.sms.status;

    if (status.isGranted) {
      print("📱 SMS permission already granted. You're good.");
      return true;
    } else {
      final result = await Permission.sms.request();
      if (result.isGranted) {
        print("✅ SMS permission granted after asking.");
        return true;
      } else {
        print("🚫 SMS permission denied. RIP SMS dreams.");
        return false;
      }
    }
  }

  static Future<void> openSettings() async {
    try {
      await openAppSettings();
      print("🔧 Opening app settings for manual permission adjustment.");
    } catch (e) {
      print("❌ Failed to open app settings: $e");
    }
  }
}
