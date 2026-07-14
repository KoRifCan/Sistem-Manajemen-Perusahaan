import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy HH:mm', 'id').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'id').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'id').format(date);
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  static String generateNIP(DateTime joinDate, int sequence) {
    return '${joinDate.year}${joinDate.month.toString().padLeft(2, '0')}${sequence.toString().padLeft(4, '0')}';
  }

  static int calculateLeaveDays(DateTime start, DateTime end) {
    int days = 0;
    DateTime current = start;
    while (!current.isAfter(end)) {
      if (current.weekday != DateTime.saturday && current.weekday != DateTime.sunday) {
        days++;
      }
      current = current.add(const Duration(days: 1));
    }
    return days;
  }
}
