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
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: widget.navigationShell,
        ),
        bottomNavigationBar: GlassmorphicBottomNavigationBar(
            selectedIndex: selectedIndex, onItemTapped: _goBranch),
      ),
    );
  }
}
