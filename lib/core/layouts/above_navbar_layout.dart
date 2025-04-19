import 'package:expense_manager/core/helpers/utils.dart';
import 'package:flutter/material.dart';

class AboveNavbarLayout extends StatelessWidget {
  final Widget child;
  const AboveNavbarLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppUtils.getNavbarHeight(context)),
      child: child,
    );
  }
}
