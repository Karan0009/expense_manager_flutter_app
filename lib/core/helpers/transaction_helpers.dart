import 'package:intl/intl.dart';

class TransactionHelpers {
  static String formatStringAmount(String? amount) {
    if (amount == null || amount.isEmpty) {
      return "₹0.00";
    }
    int? amountInt = int.tryParse(amount);
    if (amountInt == null) {
      return "₹0.00";
    }

    return formatIndianCurrency(amountInt / 100);
  }

  static double getAmountFromDbAmount(String? amount) {
    if (amount == null || amount.isEmpty) {
      return 0;
    }

    int? amountInt = int.tryParse(amount);
    if (amountInt == null) {
      return 0;
    }

    return amountInt / 100;
  }

  static String formatIndianCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount).trim();
  }
}
