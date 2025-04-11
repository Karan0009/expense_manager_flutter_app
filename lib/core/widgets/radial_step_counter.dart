import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class RadialStepCounter extends StatelessWidget {
  final double diameter;
  final int current;
  final int total;

  const RadialStepCounter({
    super.key,
    required this.diameter,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    double progress = current / total;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: diameter,
          height: diameter,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            backgroundColor: ColorsConfig.color4,
            valueColor: AlwaysStoppedAnimation<Color>(ColorsConfig.textColor4),
          ),
        ),
      ],
    );
  }
}
