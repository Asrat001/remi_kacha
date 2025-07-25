import 'package:intl/intl.dart';

class NumberUtils {
  /// Format number with comma (e.g., 1,234,567.89)
  static String formatDecimal(num number, {int decimalDigits = 2}) {
    return NumberFormat('#,##0.${'0' * decimalDigits}', 'en_US').format(number);
  }

  /// Format number in compact form (e.g., 1.2K, 1.2M)
  static String formatCompact(double number) {
    return NumberFormat.compact(locale: 'en_US').format(number);
  }

  /// Format number as currency with custom symbol
  static String formatCurrency(num number, {String symbol = '\$', int decimalDigits = 2}) {
    return NumberFormat.currency(locale: 'en_US', symbol: symbol, decimalDigits: decimalDigits).format(number);
  }



  /// Try parse string to double safely
  static double tryParse(String? value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    return double.tryParse(value.replaceAll(',', '')) ?? fallback;
  }
}
