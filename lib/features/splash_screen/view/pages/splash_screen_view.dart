import 'dart:developer';
import 'dart:io';

import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/helpers/permission_service.dart';
import 'package:expense_manager/core/helpers/sms_service.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:expense_manager/data/repositories/raw_transaction/raw_transaction_local_repository.dart';
import 'package:expense_manager/features/dashboard/view/dashboard_page_view.dart';
import 'package:expense_manager/features/login_page/view/pages/login_page_view.dart';
import 'package:expense_manager/features/sms_permission_screen/view/pages/sms_permission_page_view.dart';
import 'package:expense_manager/features/splash_screen/viewmodel/splash_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreenView extends ConsumerWidget {
  static const String routePath = '/';
  const SplashScreenView({super.key});

  static const initSuccessKey = 'INIT_SUCCESS';
  static const contextErrorKey = 'CONTEXT_ERR';
  static const platformNotAndroidKey = 'PLATFORM_NOT_ANDROID';
  static const permissionNotGrantedKey = 'PERMISSION_NOT_GRANTED';
  static const initFailedKey = 'INIT_FAILED';

  Future<Map<String, dynamic>> _initSmsPermissionCheckProcess(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      if (!Platform.isAndroid) {
        return {'action': platformNotAndroidKey};
      }

      if (!(await PermissionService.isSmsPermissionGranted())) {
        return {'action': permissionNotGrantedKey};
      }

      // _initSmsService(ref);

      return {'action': initSuccessKey};
    } catch (error) {
      // TODO: HANLE NOT ABLE TO CHECK PERMISSION
      log('error in _initSmsPermissionCheckProcess', error: error);
      return {'action': initFailedKey};
    }
  }

  Future<void> _initSmsService(WidgetRef ref) async {
    Future.microtask(() async {
      try {
        SmsService().initialize(
          allowedSenders: AppConfig.allowedSmsHeaders,
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
          },
        );
      } catch (er) {
        // TODO: HANDLE IF NOT ABLE TO INIT SMS SERVICE
        log('error in _initSmsService', error: er);
        rethrow;
      }
    });
  }

  Future<void> _navigateAfterLoginCheck(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final smsInitResponse = await _initSmsPermissionCheckProcess(context, ref);

    switch (smsInitResponse['action']) {
      case initSuccessKey:
      case platformNotAndroidKey:
        if (context.mounted) _navigateToDashboard(context);
        break;
      case permissionNotGrantedKey:
        if (context.mounted) _navigateToSmsPermissionScreen(context);
        break;
      case contextErrorKey:
      default:
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenState = ref.watch(splashScreenViewModelProvider);

    return tokenState.when(
      data: (token) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (token != null) {
            await _navigateAfterLoginCheck(context, ref);
          } else {
            _navigateToLoginScreen(context);
          }
        });
        return const SizedBox();
      },
      error: (error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToLoginScreen(context);
        });
        return const SizedBox();
      },
      loading: () => Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/piggy_img.png',
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxWidth * 0.3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _navigateToDashboard(BuildContext context) {
  context.pushReplacement(DashboardPageView.routePath);
}

void _navigateToSmsPermissionScreen(BuildContext context) {
  context.push(SmsPermissionPageView.routePath);
}

void _navigateToLoginScreen(BuildContext context) {
  context.pushReplacement(LoginPageView.routePath);
}
