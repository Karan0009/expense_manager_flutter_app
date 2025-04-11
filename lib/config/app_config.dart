// import 'dart:io';

class AppConfig {
  static const devMode = true;
  static const isLoggedIn = false;
  static const logHttp = true;

  static const baseApiUrl = "https://api.fabnest.in/api/lekhakaar/";
  // static String baseApiUrl = Platform.isAndroid
  //     ? "http://10.0.0.2:3000/api/lekhakaar"
  //     : "http://localhost:3000/api/lekhakaar/";

  static const String appName = "Expense Manager";
  static const String appVersion = "1.0.0";

  static const int initialOtpResendTime = 15;

  static const String summaryTypeDaily = 'daily';
  static const String summaryTypeWeekly = 'weekly';
  static const String summaryTypeMonthly = 'monthly';
  static const String summaryTypeQuarterly = 'quarterly';
  static const String summaryTypeYearly = 'yearly';

  static const String sortByAsc = 'ASC';
  static const String sortByDesc = 'DESC';
}

enum DateRangeType { week, month, year }
