import 'package:another_telephony/telephony.dart';

class SmsService {
  final Telephony _telephony = Telephony.instance;

  /// Initialize the service
  /// [allowedSenders] - List of sender IDs like 'VK-ICICIB'
  /// [onMessageReceived] - Callback when a valid SMS is received
  void initialize({
    required List<String> allowedSenders,
    required Function(String message) onMessageReceived,
  }) async {
    final bool? permissionGranted =
        await _telephony.requestPhoneAndSmsPermissions;

    if (permissionGranted ?? false) {
      _telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          final String? sender = message.address;
          final String body = message.body ?? '';

          print("📨 Incoming SMS from: $sender");
          // todo: use below & allowedSenders.contains(sender)
          if (sender != null) {
            print("✅ Sender matched. Delivering SMS.");
            onMessageReceived(body);
          } else {
            print("🚫 Sender not allowed. Ignored.");
          }
        },
        listenInBackground: false,
      );
    } else {
      print("❌ SMS permission denied.");
    }
  }

  final Telephony telephony = Telephony.instance;

  void checkAndRequestSmsPermission() async {
    final bool? permissionsGranted = await telephony.requestSmsPermissions;

    if (permissionsGranted ?? false) {
      print("✅ SMS permission granted. Proceed, soldier.");
    } else {
      print("🚫 Permission denied. App can’t read incoming SMS.");
    }
  }
}
