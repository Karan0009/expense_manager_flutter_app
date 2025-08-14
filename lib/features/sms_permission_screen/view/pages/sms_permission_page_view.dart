import 'dart:developer';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/permission_service.dart';
import 'package:expense_manager/core/helpers/sms_service.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:expense_manager/data/repositories/raw_transaction/raw_transaction_local_repository.dart';
import 'package:expense_manager/features/sms_permission_screen/view/widgets/sms_example_card.dart';
import 'package:flutter/material.dart';

class SmsPermissionPageView extends StatelessWidget {
  static const String routePath = '/sms-permission';
  const SmsPermissionPageView({super.key});

  void _handlePermissionRequest(BuildContext context) async {
    final granted = await PermissionService.askSmsPermission();

    if (!context.mounted) return;

    if (granted) {
      SmsService().initialize(
          allowedSenders: [],
          onMessageReceived: (message) async {
            Future.microtask(() async {
              log("📨 Received SMS: $message");
              final repository = RawTransactionLocalRepository(
                restClient: RestClient(
                  authLocalRepository: AuthLocalRepository(),
                ),
              );
              final result = await repository.create(
                type: AppConfig.rawTransactionTypeSMS,
                data: message,
              );
              log("📨 SMS saved");
              result.fold((failure) {
                log('Failed to save sms');
              }, (success) {
                log('sms saved successfully');
              });
            });
          });

      _navigateToDashboard(context);
      // Permission granted, proceed with the next steps
      AppUtils.showSnackBar(
          context, "📩 Permission granted! You're good to go.");
      // Navigate to the next screen or start reading SMS
    } else {
      AppUtils.showSnackBar(context, "🚫 SMS permission denied.");
    }
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Automatically add expenses, even in the background (If you allow)',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Expensio adds expenses by reading SMSes with banks and fintech codes',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const SmsExampleCard(),
              const SizedBox(height: 16),

              const Spacer(),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                  decoration: BoxDecoration(
                    color: ColorsConfig.color5,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "All your info is end-to-end secured",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: ColorsConfig.color9,
                          fontSize: 12,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                isDisabled: false,
                buttonText: 'Give SMS Permission',
                isLoading: false,
                onPressed: () => _handlePermissionRequest(context),
              ),
              const SizedBox(height: 12),
              CustomButton(
                onPressed: () {
                  _navigateToDashboard(context);
                },
                isLoading: false,
                buttonText: 'Add Expenses Manually',
                containerHeight: 50,
                containerWidth: 162,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  backgroundColor: ColorsConfig.bgColor1.withValues(alpha: 0.9),
                  textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: ColorsConfig.color4,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                containerPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                containerStyle: BoxDecoration(
                  color: ColorsConfig.bgColor1,
                  border: Border.all(
                    color: ColorsConfig.color4,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // OutlinedButton(
              //   onPressed: () {
              //     // Navigate to manual entry or show another screen
              //   },
              //   style: OutlinedButton.styleFrom(
              //     foregroundColor: Colors.white,
              //     side: const BorderSide(color: Colors.white24),
              //     minimumSize: const Size.fromHeight(50),
              //   ),
              //   child: const Text("Add Expenses Manually"),
              // ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
