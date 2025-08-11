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
  static const int restClientGetMaxLimit = 10;
  static const int uncategorizedSubCatId = 1;

  static const String rawTransactionTypeWAText = 'WA_TEXT';
  static const String rawTransactionTypeWAImage = 'WA_IMAGE';
  static const String rawTransactionTypeSMS = 'SMS_READ';

  static const String rawTransactionsLocalTable = 'raw_transactions';

  static const List<String> allowedSmsHeaders = [
    'HDFC',
    'ICICI',
    'PNB',
    'SBI',
    'KOTAK',
    'AXIS',
    'YES',
    'INDUS',
    'IDFC',
    'BARODA',
    'BOBSMS',
    'UNIONS',
    'UBISMS',
    'FEDSMS',
    'FEDBNK',
    'AUBANK',
    // TODO: REMOVE AFTER TESTING
    '+917988195437',
  ];

  static const String logoutTypeSelf = 'self';
  static const String logoutTypeAll = 'all';
  static const String logoutTypeAllOthers = 'all_others';
}

enum DateRangeType { week, month, year }
