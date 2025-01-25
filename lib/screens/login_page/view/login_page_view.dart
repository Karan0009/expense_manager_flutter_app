import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_manager/config/colors_config.dart';
import 'package:expense_manager/core/icomoon_icons.dart';
import 'package:expense_manager/screens/login_page/controller/login_page_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageView extends ConsumerWidget {
  static const String routePath = '/login';
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginPageViewModelProvider);
    final loginViewModel = ref.read(loginPageViewModelProvider.notifier);

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
                      'Enter your phone number',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        color: ColorsConfig.textColor2,
                        fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.phone,
                      cursorColor: ColorsConfig.textColor2,
                      onChanged: loginViewModel.onPhoneNumberChanged,
                      cursorHeight: 17,
                      cursorWidth: 1,
                      style: TextStyle(
                        color: ColorsConfig.textColor2,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Center(
                          heightFactor: 0.5,
                          widthFactor: 0,
                          child: Container(
                            height: 25,
                            width: 25,
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(bottom: 7),
                            decoration: BoxDecoration(
                              color: ColorsConfig.color1,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              size: 15,
                              Icons.phone_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        hintText: '85XX XXX X20',
                        hintStyle: TextStyle(
                          color: ColorsConfig.textColor1,
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                        filled: true,
                        fillColor: ColorsConfig.bgColor1,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          heightFactor: 0.5,
                          child: Checkbox(
                            value: loginState.isTermsAccepted,
                            onChanged: loginViewModel.onCheckboxChanged,
                            activeColor: ColorsConfig.color1,
                          ),
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'By continuing, you agree to our ',
                              style: TextStyle(
                                color: ColorsConfig.textColor3,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: ColorsConfig.color2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle Terms & Conditions tap here
                                      log('Terms & Conditions clicked!');
                                    },
                                ),
                                TextSpan(
                                  text: ' and ',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: ColorsConfig.color2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle Privacy Policy tap here
                                      log('Privacy Policy clicked!');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => loginViewModel.onLoginClicked(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: ColorsConfig.color2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Login',
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
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () =>
                            loginViewModel.onCreateAccountClicked(context),
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
                            mainAxisSize: MainAxisSize
                                .min, // Ensures the Row takes only the space it needs
                            children: [
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  color: ColorsConfig.color3,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icomoon
                                    .arrowUpRight2, // Replace with any icon you want
                                color: ColorsConfig.color3,
                                size: 12, // Adjust size as needed
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
