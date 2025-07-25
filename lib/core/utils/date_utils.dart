
import 'package:intl/intl.dart';

class DateUtilsHelper {

  static String formatRelativeTime(String isoTimestamp) {
    final date = DateTime.parse(isoTimestamp).toLocal();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return DateFormat.yMMMd().format(date); // e.g. Jul 22, 2025
    }
  }

  static String formatFullDate(String isoTimestamp) {
    final date = DateTime.parse(isoTimestamp).toLocal();
    return DateFormat.yMMMMEEEEd().add_jm().format(date); // e.g. Tuesday, July 22, 2025 3:45 PM
  }

  static String shortDate(String isoTimestamp) {
    final date = DateTime.parse(isoTimestamp).toLocal();
    return DateFormat.MMMd().format(date); // e.g. Jul 22
  }
}
