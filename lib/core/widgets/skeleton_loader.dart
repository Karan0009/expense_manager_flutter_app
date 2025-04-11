import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const SkeletonLoader({
    super.key,
    this.width = 40,
    this.height = 40,
    this.borderRadius = const BorderRadius.all(Radius.circular(1)),
    this.baseColor = ColorsConfig.color1,
    this.highlightColor = ColorsConfig.color4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
