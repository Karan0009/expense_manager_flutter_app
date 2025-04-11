import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/icomoon_icons.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/custom_input_field.dart';
import 'package:expense_manager/features/login_page/view/pages/login_page_view.dart';
import 'package:expense_manager/features/login_page/viewmodel/auth_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountPageView extends ConsumerStatefulWidget {
  const CreateAccountPageView({super.key});
  static const String routePath = '/create-account';

  @override
  ConsumerState<CreateAccountPageView> createState() =>
      _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPageView> {
  final phoneController = TextEditingController();
  bool isTermsAndConditionsAccepted = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;
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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.1),
                      Text(
                        'Enter your phone number',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 20),
                      CustomInputField(
                        hintText: '85XXXXXX20',
                        controller: phoneController,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
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
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            heightFactor: 0.5,
                            child: Checkbox(
                              value: isTermsAndConditionsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  isTermsAndConditionsAccepted = value!;
                                });
                              },
                              activeColor: ColorsConfig.color1,
                            ),
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: 'By continuing, you agree to our ',
                                style: Theme.of(context).textTheme.bodySmall,
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color:
                                              Theme.of(context).highlightColor,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color:
                                              Theme.of(context).highlightColor,
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
                        child: CustomButton(
                          isDisabled: false,
                          buttonText: 'Sign Up',
                          isLoading: isLoading,
                          onPressed: () async {
                            final isError = ref
                                .read(authViewModelProvider.notifier)
                                .validateAuthForm(phoneController.text,
                                    isTermsAndConditionsAccepted);
                            if (isError != null) {
                              AppUtils.showSnackBar(context, isError);
                              return;
                            }

                            await ref
                                .read(authViewModelProvider.notifier)
                                .getOtp(
                                  phoneController.text,
                                  isTermsAndConditionsAccepted,
                                );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => AppUtils.navigateToPage(
                            context: context,
                            routePath: LoginPageView.routePath,
                          ),
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
                              mainAxisSize: MainAxisSize
                                  .min, // Ensures the Row takes only the space it needs
                              children: [
                                Text(
                                  'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: ColorsConfig.color3),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icomoon
                                      .arrowUpRight2, // Replace with any icon you want
                                  color: Theme.of(context).secondaryHeaderColor,
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
            ),
          );
        },
      ),
    );
  }
}
