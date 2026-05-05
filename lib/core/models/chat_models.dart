/// Represents a single chat message.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final String text;
  final bool isSent;
  final DateTime timestamp;
  final bool isRead;

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Represents a conversation / contact in the home list.
class Conversation {
  const Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
    this.avatarInitial = 'P',
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;
  final String avatarInitial;
  final bool isFavorite;

  bool get hasUnread => unreadCount > 0;

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
