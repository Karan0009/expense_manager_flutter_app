import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 23,
      height: 23,
      child: Center(
        child: CircularProgressIndicator(
          color: ColorsConfig.textColor2,
        ),
      ),
    );
  }
}
