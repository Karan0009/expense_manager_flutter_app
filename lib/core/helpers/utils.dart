import 'dart:math';

import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static void showSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        GlassmorphicSnackBar(
          message: message,
          duration: duration,
        ),
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

  static int? safeParseInt(Object? input) {
    if (input == null) return null;

    if (input is int) return input;

    if (input is String) return int.tryParse(input);

    return null;
  }

  static Map<String, dynamic> getFormattedDateRange(
    DateTime date,
    DateRangeType type, {
    bool isInputDateStartDate = false,
    bool orderAscending = true,
  }) {
    late DateTime start;
    late DateTime end;

    switch (type) {
      case DateRangeType.week:
        if (isInputDateStartDate) {
          start = date;
          end = orderAscending
              ? start.add(Duration(days: 6))
              : start.subtract(Duration(days: 6));
        } else {
          start = date.subtract(Duration(days: date.weekday - 1));
          end = orderAscending
              ? start.add(Duration(days: 6))
              : start.subtract(Duration(days: 6));
        }
        break;
      case DateRangeType.month:
        if (isInputDateStartDate) {
          start = date;
          end = orderAscending
              ? DateTime(date.year, date.month + 1, 0)
              : DateTime(date.year, date.month, 1);
        } else {
          start = DateTime(date.year, date.month, 1);
          end = orderAscending
              ? DateTime(date.year, date.month + 1, 0)
              : DateTime(date.year, date.month, 1);
        }
        break;
      case DateRangeType.year:
        if (isInputDateStartDate) {
          start = date;
          end = orderAscending
              ? DateTime(date.year, 12, 31)
              : DateTime(date.year, 1, 1);
        } else {
          start = DateTime(date.year, 1, 1);
          end = orderAscending
              ? DateTime(date.year, 12, 31)
              : DateTime(date.year, 1, 1);
        }
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

  static double getNavbarHeight(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return max(screenSize.height * 0.1, 50);
  }

  static Future<void> delay(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  static String formatDate(DateTime date, {String format = 'yMMMMd'}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  static DateTime? parseDate(String dateString,
      {String format = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  static bool isValidEmail(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  static bool isValidNumber(String? str) {
    if (str == null) return false;

    final regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(str);
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static Color randomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
