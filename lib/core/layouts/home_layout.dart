import 'package:expense_manager/globals/components/glassmorphic_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedIndex = 0;

  void _goBranch(String route) {
    context.go(route);
    // log("$index");
    // widget.navigationShell.goBranch(
    //   index,
    //   initialLocation: index == widget.navigationShell.currentIndex,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          body: Stack(
        children: [
          // Your main content that should extend behind the navbar
          Positioned.fill(
            child: widget.navigationShell,
          ),
          // Position your bottom navigation bar at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GlassmorphicBottomNavigationBar(
              selectedIndex: selectedIndex,
              onItemTapped: _goBranch,
            ),
          ),
        ],
      )
// SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: widget.navigationShell,
//         ),
          // bottomNavigationBar: GlassmorphicBottomNavigationBar(
          //   selectedIndex: selectedIndex,
          //   onItemTapped: _goBranch,
          // ),
          ),
    );
  }
}
