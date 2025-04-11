import 'dart:math';

import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppUtils {
  static void showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        GlassmorphicSnackBar(message: message),
      );
    }
  }

  static void navigateToPage({
    required BuildContext context,
    required String routePath,
    Object? extra,
    bool isReplaced = false,
  }) {
    if (context.mounted) {
      if (isReplaced) {
        context.pushReplacement(routePath, extra: extra);
        return;
      }
      context.go(
        routePath,
        extra: extra,
      );
    }
  }

  static BigInt safeParseBigInt(String input) {
    try {
      return BigInt.parse(input);
    } catch (e) {
      return BigInt.zero;
    }
  }

  static int? safeParseInt(String? input) {
    if (input == null) return null;
    return int.tryParse(input);
  }

  static Map<String, dynamic> getFormattedDateRange(
      DateTime date, DateRangeType type) {
    late DateTime start;
    late DateTime end;

    switch (type) {
      case DateRangeType.week:
        start = date.subtract(Duration(days: date.weekday - 1));
        end = start.add(Duration(days: 6));
        break;
      case DateRangeType.month:
        start = DateTime(date.year, date.month, 1);
        end = DateTime(date.year, date.month + 1, 0);
        break;
      case DateRangeType.year:
        start = DateTime(date.year, 1, 1);
        end = DateTime(date.year, 12, 31);
        break;
    }

    List<DateTime> allDates = [];
    DateTime current = start;

    while (!current.isAfter(end)) {
      allDates.add(current);
      current = current.add(Duration(days: 1));
    }

    return {
      'start': start,
      'end': end,
      'dates': allDates,
    };
  }

  static double safeDivide(num numerator, num denominator,
      {double fallback = 0.0}) {
    return denominator != 0 ? numerator / denominator : fallback;
  }

  static double degreeToRadian(double degrees) {
    return degrees * (pi / 180);
  }

  static double radianToDegree(double radians) {
    return radians * (180 / pi);
  }
}
