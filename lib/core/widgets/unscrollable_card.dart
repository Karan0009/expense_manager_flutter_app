import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class UnscrollableCard extends StatelessWidget {
  final Widget child;
  const UnscrollableCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ColorsConfig.bgColor2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsConfig.color5,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
