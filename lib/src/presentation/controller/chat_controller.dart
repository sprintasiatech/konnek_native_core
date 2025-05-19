import 'package:konnek_native_core/src/data/models/response/get_conversation_response_model.dart';

abstract class ChatItem {}

class DateSeparator extends ChatItem {
  final String label;

  DateSeparator(this.label);
}

class ChatController {
  static List<ChatItem> buildChatListWithSeparators(List<ConversationList> messages) {
    messages.sort((a, b) => a.messageTime!.compareTo(b.messageTime!)); // optional: sort oldest to newest
    // List<ChatItem> result = [];
    List<ChatItem> result = [];

    for (int i = 0; i < messages.length; i++) {
      final current = messages[i];
      final previous = i > 0 ? messages[i - 1] : null;

      if (previous == null || !isSameDate(current.messageTime!, previous.messageTime!)) {
        result.add(DateSeparator(formatDate(current.messageTime!)));
      }

      result.add(current);
    }

    return result;
  }

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) return "Today";
    if (msgDate == yesterday) return "Yesterday";
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  static String _monthName(int month) {
    const months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[month];
  }
}
