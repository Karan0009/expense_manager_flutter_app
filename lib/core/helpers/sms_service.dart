import 'dart:developer';

import 'package:another_telephony/telephony.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:expense_manager/data/repositories/raw_transaction/raw_transaction_local_repository.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(SmsMessage message) async {
  final String? sender = message.address;
  final String body = message.body ?? '';

  log("📨 Incoming SMS from: $sender");
  if (sender != null && AppConfig.allowedSmsHeaders.contains(sender)) {
    log("✅ Sender matched. Reading SMS.");
    await RawTransactionLocalRepository(
      restClient: RestClient(authLocalRepository: AuthLocalRepository()),
    ).create(
      type: AppConfig.rawTransactionTypeSMS,
      data: body,
    );
  } else {
    log("🚫 Sender not allowed. Ignored.");
  }
}

class SmsService {
  final Telephony _telephony = Telephony.instance;

  /// Initialize the service
  /// [allowedSenders] - List of sender IDs like 'VK-ICICIB'
  /// [onMessageReceived] - Callback when a valid SMS is received
  void initialize({
    required List<String> allowedSenders,
    required Function(String message) onMessageReceived,
  }) async {
    final bool permissionGranted =
        await _telephony.requestPhoneAndSmsPermissions ?? false;

    if (permissionGranted) {
      _telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          final String? sender = message.address;
          final String body = message.body ?? '';

          log("📨 Incoming SMS from: $sender");
          if (sender != null && allowedSenders.contains(sender)) {
            log("✅ Sender matched. Reading body.");
            onMessageReceived(body);
          } else {
            log("🚫 Sender not allowed. Ignored.");
          }
        },
        onBackgroundMessage: backgroundMessageHandler,
        listenInBackground: true,
      );
    } else {
      print("❌ SMS permission denied.");
    }
  }

  final Telephony telephony = Telephony.instance;

  void checkAndRequestSmsPermission() async {
    final bool? permissionsGranted = await telephony.requestSmsPermissions;

    if (permissionsGranted ?? false) {
      print("SMS permission granted");
    } else {
      print("🚫 Permission denied. App can’t read incoming SMS.");
    }
  }
}
