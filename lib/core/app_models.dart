/// Represents a single notification item.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.avatarInitial = 'P',
    this.type = NotificationType.message,
  });

  final String id;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String avatarInitial;
  final NotificationType type;

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

enum NotificationType { message, mention, system }

/// Minimal user profile used across auth and menu pages.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarInitial = 'U',
    this.isDoNotDisturb = false,
  });

  final String id;
  final String name;
  final String email;
  final String avatarInitial;
  final bool isDoNotDisturb;

  AppUser copyWith({
    String? name,
    String? email,
    String? avatarInitial,
    bool? isDoNotDisturb,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarInitial: avatarInitial ?? this.avatarInitial,
      isDoNotDisturb: isDoNotDisturb ?? this.isDoNotDisturb,
    );
  }
}
