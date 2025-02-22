import 'package:expense_manager/config/colors_config.dart';
import 'package:expense_manager/screens/user_account_page/controller/user_account_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAccountPageView extends ConsumerWidget {
  static const String routePath = '/account';
  const UserAccountPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userAccountPageViewModelProvider);
    final viewModel = ref.read(userAccountPageViewModelProvider.notifier);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        // final screenSize = MediaQuery.of(context).size;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : constraints.maxWidth * 0.2,
              ),
              child: SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        color: ColorsConfig.textColor2,
                        fontFamily: GoogleFonts.instrumentSerif().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: constraints.maxWidth * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorsConfig.textColor1,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                          Text(
                            '+91 7988195437',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorsConfig.color2,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      // height: 200,
                      // margin: EdgeInsets.only(top: double.infinity),
                      child: ElevatedButton(
                        onPressed: () => viewModel.logoutButtonOnClick(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: ColorsConfig.color3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: state.isLoading
                            ? Container(
                                color: Colors.transparent,
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: ColorsConfig.textColor2,
                                  ),
                                ),
                              )
                            : Text(
                                'Logout',
                                style: TextStyle(
                                  color: ColorsConfig.textColor2,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
