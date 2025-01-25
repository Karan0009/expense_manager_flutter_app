import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class Utils {
  // 1. Delay Function
  static Future<void> delay(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  // 2. Date Formatting (Using Intl)
  static String formatDate(DateTime date, {String format = 'yMMMMd'}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  // 3. Time Ago (Relative Time Calculation)
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

  // 4. Parse String to DateTime
  static DateTime? parseDate(String dateString, {String format = 'y-MM-dd'}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  // 5. Validate Email
  static bool isValidEmail(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  // 6. Capitalize First Letter of String
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // 7. Generate Random Color
  static Color randomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  // 8. Safe Division
  static double safeDivide(num numerator, num denominator,
      {double fallback = 0.0}) {
    return denominator != 0 ? numerator / denominator : fallback;
  }
}
