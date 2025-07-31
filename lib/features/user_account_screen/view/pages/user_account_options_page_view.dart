import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/skeleton_loader.dart';
import 'package:expense_manager/features/login_page/view/pages/login_page_view.dart';
import 'package:expense_manager/features/login_page/viewmodel/auth_viewmodel.dart';
import 'package:expense_manager/features/user_account_screen/view/pages/offline_transactions_page_view.dart';
import 'package:expense_manager/features/user_account_screen/view/widgets/user_account_list_item.dart';
import 'package:expense_manager/features/user_account_screen/view/widgets/user_account_option_row.dart';
import 'package:expense_manager/features/user_account_screen/viewmodel/user_account_viewmodel/user_account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserAccountOptionsPageView extends ConsumerStatefulWidget {
  static const String routePath = '/user-account';
  const UserAccountOptionsPageView({super.key});

  @override
  ConsumerState<UserAccountOptionsPageView> createState() =>
      _UserAccountOptionsPageViewState();
}

class _UserAccountOptionsPageViewState
    extends ConsumerState<UserAccountOptionsPageView> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  FutureVoid logoutHandler(String logoutType) async {
    final result = await ref
        .read(authViewModelProvider.notifier)
        .logout(AppConfig.logoutTypeSelf);
    if (result) {
      if (mounted) {
        context.pushReplacement(LoginPageView.routePath);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logout failed. Please try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔄 UserAccountOptionsPageView rebuilt');
    final state = ref.watch(userAccountViewModelProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
            maxWidth: constraints.maxWidth,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar and Name
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: ColorsConfig.color2,
                      ),
                      // CircleAvatar(
                      //   radius: 16,
                      //   backgroundColor: Colors.black,
                      //   child: Icon(Icons.edit, color: Colors.white, size: 16),
                      // ),
                      Positioned(
                        left: 63,
                        bottom: 2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: ColorsConfig.color5,
                            border: Border.all(
                              color: ColorsConfig.color2,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child:
                              Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Finance Guru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ref.watch(userAccountViewModelProvider).when(
                      data: (user) {
                        final date = DateTime.tryParse(user?.created_at ?? '');
                        if (date == null) {
                          return const Text(
                            'Since __',
                            style: TextStyle(color: Colors.grey),
                          );
                        }

                        return Text(
                          "Since ${AppUtils.formatDate(date, format: 'MMM dd, yyyy')}",
                          style: TextStyle(color: Colors.grey),
                        );
                      },
                      error: (err, _) => const Text(
                            'Err',
                            style: TextStyle(color: Colors.grey),
                          ),
                      loading: () => SkeletonLoader(
                            height: 20,
                            width: 50,
                            baseColor: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            highlightColor:
                                Theme.of(context).cardColor.withValues(
                                      alpha: 2.5,
                                    ),
                          )),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsConfig.textColor5,
                          ),
                    ),
                  ),

                  UserAccountOptionRow(
                    icon: Icons.phone_outlined,
                    optionName: 'Phone Number',
                    value: state.hasValue
                        ? "${state.value?.country_code} ${state.value?.phone_number}"
                        : null,
                    onPressed: () {},
                  ),
                  UserAccountOptionRow(
                    icon: Icons.person_outline,
                    optionName: 'Name',
                    onPressed: () {},
                  ),
                  UserAccountOptionRow(
                    icon: Icons.work_outline,
                    optionName: 'Occupation',
                    onPressed: () {},
                  ),
                  UserAccountOptionRow(
                    icon: Icons.location_on_outlined,
                    optionName: 'City',
                    onPressed: () {},
                  ),

                  ...listSpacer(context),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Offline',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsConfig.textColor5,
                          ),
                    ),
                  ),

                  UserAccountListItem(
                    icon: Icons.backup,
                    optionName: 'Transactions',
                    onPressed: () {
                      print('Transactions pressed');
                      context.push(
                        OfflineTransactionsPageView.routePath,
                      );
                    },
                  ),

                  ...listSpacer(context),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              ColorsConfig.color5,
                            ),
                          ),
                          isDisabled: false,
                          buttonText: 'Logout',
                          isLoading: false,
                          onPressed: () async {
                            await logoutHandler(AppConfig.logoutTypeSelf);
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: CustomButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              ColorsConfig.color5,
                            ),
                          ),
                          isDisabled: false,
                          buttonText: 'Logout all',
                          isLoading: false,
                          onPressed: () async {
                            await logoutHandler(AppConfig.logoutTypeAll);
                          },
                        ),
                      )
                    ],
                  ),

                  /// EXPENSES SECTION
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     'Expenses',
                  //     style:
                  //         Theme.of(context).textTheme.bodySmall!.copyWith(
                  //               fontWeight: FontWeight.w600,
                  //               color: ColorsConfig.textColor5,
                  //             ),
                  //   ),
                  // ),
                  // UserAccountOptionRow(
                  //   icon: Icons.sentiment_satisfied_alt,
                  //   optionName: 'Salary',
                  //   onPressed: () {},
                  // ),
                  // UserAccountOptionRow(
                  //   icon: Icons.cached,
                  //   optionName: 'Fixed Costs',
                  //   onPressed: () {},
                  // ),
                  // UserAccountOptionRow(
                  //   icon: Icons.calculate,
                  //   optionName: 'Budgets',
                  //   onPressed: () {},
                  // ),
                  // UserAccountOptionRow(
                  //   icon: Icons.currency_rupee,
                  //   optionName: 'Currency',
                  //   onPressed: () {},
                  // ),

                  /// BOTTOM MARGIN FOR NAVBAR
                  SizedBox(height: AppUtils.getNavbarHeight(context)),
                ]),
          ),
        );
      },
    );
  }
}

List<Widget> listSpacer(context) => [
      Container(
        height: 2,
        color: const Color.fromRGBO(24, 29, 39, 1),
        width: MediaQuery.of(context).size.width,
      ),
      const SizedBox(height: 10),
    ];
