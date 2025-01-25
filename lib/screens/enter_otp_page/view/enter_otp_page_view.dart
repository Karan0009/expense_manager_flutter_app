import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_manager/config/colors_config.dart';
import 'package:expense_manager/screens/enter_otp_page/controller/enter_otp_page_viewmodel.dart';
import 'package:expense_manager/screens/login_page/controller/login_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class EnterOtpPageView extends ConsumerWidget {
  static const String routePath = '/login/otp';
  const EnterOtpPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginPageViewModelProvider);
    // final otpPageState = ref.watch(enterOtpPageViewModelProvider);
    final viewModel = ref.read(enterOtpPageViewModelProvider.notifier);

    final defaultPinTheme = PinTheme(
      width: 51,
      height: 51,
      textStyle: GoogleFonts.inter(
        fontSize: 16,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Text(
                      'Please Enter OTP',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        color: ColorsConfig.textColor2,
                        fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Sent to +91 ${loginState.phoneNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorsConfig.textColor2.withValues(alpha: 0.75),
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration?.copyWith(
                          border: Border(
                            bottom: BorderSide(
                              color: ColorsConfig.color2,
                            ),
                          ),
                        ),
                      ),
                      onCompleted: (pin) {
                        log(pin);
                        // Handle OTP completion
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => viewModel.onLoginClicked(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: ColorsConfig.color2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Submit OTP',
                          style: TextStyle(
                            color: ColorsConfig.textColor2,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      GestureDetector(
                        onTap: () => viewModel.onCreateAccountClicked(context),
                        child: DottedBorder(
                          color: ColorsConfig.color3,
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
                                color: ColorsConfig.color3,
                                size: 12,
                              ),
                              // const SizedBox(width: 4),
                              Text(
                                'Change Number',
                                style: TextStyle(
                                  color: ColorsConfig.color3,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Resent OTP in 15',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: ColorsConfig.textColor2.withValues(
                            alpha: 0.75,
                          ),
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
      backgroundColor: ColorsConfig.bgColor1,
    );
  }
}
