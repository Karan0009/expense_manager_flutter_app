import 'dart:math';
import 'dart:ui';

import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/features/dashboard/view/dashboard_page_view.dart';
import 'package:expense_manager/globals/providers/bottom_navbar_viewmodel.dart';
// import 'package:expense_manager/screens/expenses_dashboard_page/view/expenses_dashboard_page_view.dart';
// import 'package:expense_manager/screens/user_account_page/view/user_account_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlassmorphicBottomNavigationBar extends ConsumerStatefulWidget {
  final int selectedIndex;
  final Function(String) onItemTapped;

  final List<Map<String, dynamic>> pages = [
    {"icon": Icons.dashboard, "route": DashboardPageView.routePath},
    {
      "icon": Icons.account_balance_wallet,
      "route": DashboardPageView.routePath
    },
    {"icon": Icons.bar_chart, "route": DashboardPageView.routePath},
    {"icon": Icons.person, "route": DashboardPageView.routePath}
  ];

  GlassmorphicBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  ConsumerState<GlassmorphicBottomNavigationBar> createState() =>
      _GlassmorphicBottomNavigationBarState();
}

class _GlassmorphicBottomNavigationBarState
    extends ConsumerState<GlassmorphicBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
    // Perform initialization here
  }

  @override
  void dispose() {
    // Perform cleanup here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bottomNavbarViewModelProvider);
    final viewModel = ref.read(bottomNavbarViewModelProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    double navbarHeight = max(screenSize.height * 0.11, 70);
    return
        // Stack(children: [
        //   Positioned(
        //     top: screenSize.height - navbarHeight,
        //     bottom: 0,
        //     left: -1,
        //     child:
        ClipRRect(
      clipBehavior: Clip.hardEdge,
      // clipper: MyCustomClipper(),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: Container(
            height: navbarHeight,
            width: screenSize.width * 1.006,
            // padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorsConfig.bgColor1.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ],
              border: Border(
                top: BorderSide(color: ColorsConfig.textColor2, width: 0.5),
                left: BorderSide(color: ColorsConfig.textColor2, width: 0.5),
                right: BorderSide(color: ColorsConfig.textColor2, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.pages.asMap().entries.map((data) {
                final index = data.key;
                final value = data.value;
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    viewModel.changeBottomNavbarIndex(index);
                    widget.onItemTapped(value["route"]);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 1500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          margin: EdgeInsets.only(
                            bottom: index == state.curIndex
                                ? 0
                                : screenSize.width * .029,
                            right: screenSize.width * .0422,
                            left: screenSize.width * .0422,
                          ),
                          width: screenSize.width * .128,
                          height: index == state.curIndex
                              ? screenSize.width * .005
                              : 0,
                          decoration: BoxDecoration(
                            color: ColorsConfig.textColor2,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                          ),
                        ),
                        Icon(
                          value["icon"],
                          size: screenSize.width * .076,
                          color: index == state.curIndex
                              ? ColorsConfig.textColor2
                              : ColorsConfig.color4,
                        ),
                        SizedBox(height: screenSize.width * .03),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
            // ListView.builder(
            //   itemCount: widget.pages.length,
            //   padding:
            //       EdgeInsets.symmetric(horizontal: screenSize.width * .024),
            //   scrollDirection: Axis.horizontal,
            //   itemBuilder: (context, index) =>

            // )
            // BottomNavigationBar(
            //   currentIndex: selectedIndex,
            //   onTap: onItemTapped,
            //   backgroundColor: ColorsConfig.bgColor1,
            //   elevation: 0, // Remove default shadow
            //   selectedItemColor: ColorsConfig.textColor2,
            //   unselectedItemColor: ColorsConfig.textColor1,
            //   unselectedLabelStyle: TextStyle(
            //     color: ColorsConfig.textColor1,
            //     fontFamily: GoogleFonts.inter().fontFamily,
            //     fontSize: 12,
            //     fontWeight: FontWeight.w400,
            //   ),
            //   selectedLabelStyle: TextStyle(
            //     color: ColorsConfig.textColor2,
            //     fontFamily: GoogleFonts.inter().fontFamily,
            //     fontSize: 12,
            //     fontWeight: FontWeight.w400,
            //   ),
            //   items: pages,
            ),
      ),
    );
    // )
    // ]);
    // );
  }
}
