import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/data/models/otp.dart';
import 'package:expense_manager/features/login_page/view/pages/create_account_page_view.dart';
import 'package:expense_manager/features/login_page/view/pages/login_page_view.dart';
import 'package:expense_manager/features/login_page/viewmodel/auth_viewmodel.dart';
import 'package:expense_manager/features/splash_screen/view/pages/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class EnterOtpPageView extends ConsumerStatefulWidget {
  const EnterOtpPageView({super.key});
  static const String routePath = '/login/otp';

  @override
  ConsumerState<EnterOtpPageView> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends ConsumerState<EnterOtpPageView> {
  final otpController = TextEditingController();
  int remainingResendOtpTime = AppConfig.initialOtpResendTime;
  bool isResendEnabled = false;
  Timer? _timer;
  Otp? otpInfo;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();

    phoneNumber = ref.read(authViewModelProvider)?.value?.phoneNumber;
    final currentState = ref.read(authViewModelProvider)?.value;
    otpInfo = currentState?.otpInfo;
    startResendOtpTimer();
  }

  void startResendOtpTimer() {
    _timer?.cancel();
    final retryAfter = int.parse(
        otpInfo?.retry_after ?? AppConfig.initialOtpResendTime.toString());
    setState(() {
      remainingResendOtpTime = retryAfter;
      isResendEnabled = remainingResendOtpTime <= 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingResendOtpTime > 0) {
        setState(() {
          remainingResendOtpTime--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding!');
    final defaultPinTheme = PinTheme(
      width: 51,
      height: 51,
      textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: ColorsConfig.textColor3,
          ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(0),
        border: Border(
          bottom: BorderSide(
            color: ColorsConfig.textColor2,
          ),
        ),
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16.0 : constraints.maxWidth * 0.2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Text(
                      'Please Enter OTP',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Sent to +91 $phoneNumber',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color:
                                ColorsConfig.textColor2.withValues(alpha: 0.75),
                          ),
                    ),
                    const SizedBox(height: 20),
                    Pinput(
                      length: 6,
                      autofocus: true,
                      defaultPinTheme: defaultPinTheme,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'PIN cannot be empty';
                        }
                        if (value.length != 6) {
                          return 'PIN must be 6 digits';
                        }
                        return null;
                      },
                      controller: otpController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration?.copyWith(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).highlightColor,
                            ),
                          ),
                        ),
                      ),
                      onCompleted: (pin) {
                        print(pin);
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        isDisabled: false,
                        buttonText: 'Submit OTP',
                        isLoading: false,
                        onPressed: () async {
                          final result = await ref
                              .read(authViewModelProvider.notifier)
                              .verifyOtp(
                                phoneNumber!,
                                otpController.text,
                                otpInfo?.otp_code ?? '',
                              );
                          result.fold((l) {
                            AppUtils.showSnackBar(
                                context, 'Some error occured');
                          }, (token) {
                            if (token != null) {
                              _navigateToHome(context);
                            } else {
                              AppUtils.showSnackBar(context, 'Invalid OTP');
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      GestureDetector(
                        onTap: () {
                          changePhoneNumberClickHandler(context, false);
                        },
                        child: DottedBorder(
                          color: Theme.of(context).secondaryHeaderColor,
                          strokeCap: StrokeCap.round,
                          customPath: (size) {
                            return Path()
                              ..moveTo(0, 20)
                              ..lineTo(size.width, 20);
                          },
                          dashPattern: [1, 2],
                          radius: Radius.circular(100),
                          borderType: BorderType.RRect,
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 12,
                              ),
                              // const SizedBox(width: 4),
                              Text(
                                'Change Number',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 1,
                        height: 20,
                        color: ColorsConfig.textColor2,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        child: GestureDetector(
                          onTap: () async {
                            if (phoneNumber == null) {
                              AppUtils.showSnackBar(
                                  context, 'Phone number is required');
                              return;
                            }

                            final result = await ref
                                .read(authViewModelProvider.notifier)
                                .resendOtp(phoneNumber!);

                            result.fold((l) {
                              AppUtils.showSnackBar(
                                  context, 'Some error occured');
                            }, (otp) {
                              otpController.text = "";
                              setState(() {
                                otpInfo = otp;
                              });
                              startResendOtpTimer();
                            });
                          },
                          child: isResendEnabled
                              ? DottedBorder(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  strokeCap: StrokeCap.round,
                                  customPath: (size) {
                                    return Path()
                                      ..moveTo(0, 20)
                                      ..lineTo(size.width, 20);
                                  },
                                  dashPattern: [1, 2],
                                  radius: Radius.circular(100),
                                  borderType: BorderType.RRect,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        size: 12,
                                      ),
                                      Text(
                                        'Resend OTP',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  'Resend OTP in ${getResendTimeString(remainingResendOtpTime)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        wordSpacing: 1,
                                        color:
                                            ColorsConfig.textColor2.withValues(
                                          alpha: 0.75,
                                        ),
                                      )),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _navigateToHome(BuildContext context) {
  context.pushReplacement(SplashScreenView.routePath);
}

void changePhoneNumberClickHandler(BuildContext context, bool isCreateAccount) {
  if (isCreateAccount) {
    context.pushReplacement(CreateAccountPageView.routePath);
  } else {
    context.pushReplacement(LoginPageView.routePath);
  }
}

String getResendTimeString(int remainingResendTime) {
  final minutes = (remainingResendTime / 60).floor();
  final seconds = (remainingResendTime % 60).floor();
  return '${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}';
}
