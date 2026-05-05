import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_models.dart';
import 'package:chatapp/core/app_theme.dart';
import 'package:chatapp/core/shared_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mock Data
// ─────────────────────────────────────────────────────────────────────────────

final _mockNotifications = [
  AppNotification(
    id: '1',
    senderName: 'Alex Rivera',
    message: 'Hey! Are you free tomorrow evening?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    isRead: false,
    avatarInitial: 'A',
    type: NotificationType.message,
  ),
  AppNotification(
    id: '2',
    senderName: 'Jordan Kim',
    message: 'Mentioned you in Design Team chat',
    timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
    isRead: false,
    avatarInitial: 'J',
    type: NotificationType.mention,
  ),
  AppNotification(
    id: '3',
    senderName: 'Sofia Nour',
    message: 'Can we reschedule the call to Friday?',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    isRead: false,
    avatarInitial: 'S',
    type: NotificationType.message,
  ),
  AppNotification(
    id: '4',
    senderName: 'Priya Sharma',
    message: 'Let me check and get back to you on that.',
    timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    isRead: true,
    avatarInitial: 'P',
    type: NotificationType.message,
  ),
  AppNotification(
    id: '5',
    senderName: 'Marcus Chen',
    message: 'Done! Pushed all the changes to staging.',
    timestamp: DateTime.now().subtract(const Duration(hours: 7)),
    isRead: true,
    avatarInitial: 'M',
    type: NotificationType.message,
  ),
  AppNotification(
    id: '6',
    senderName: 'ChatApp',
    message: 'Your account has been verified successfully.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
    avatarInitial: 'C',
    type: NotificationType.system,
  ),
  AppNotification(
    id: '7',
    senderName: 'Liam Torres',
    message: 'Sounds good, see you then!',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
    avatarInitial: 'L',
    type: NotificationType.message,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Notifications Page
// ─────────────────────────────────────────────────────────────────────────────

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(_mockNotifications);
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<AppNotification> get _unread =>
      _notifications.where((n) => !n.isRead).toList();

  List<AppNotification> get _read =>
      _notifications.where((n) => n.isRead).toList();

  void _markAllRead() {
    HapticFeedback.lightImpact();
    setState(() {
      _notifications = _notifications
          .map((n) => AppNotification(
                id: n.id,
                senderName: n.senderName,
                message: n.message,
                timestamp: n.timestamp,
                isRead: true,
                avatarInitial: n.avatarInitial,
                type: n.type,
              ))
          .toList();
    });
  }

  void _dismissNotification(String id) {
    setState(() => _notifications.removeWhere((n) => n.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NotificationsHeader(
          unreadCount: _unreadCount,
          onMarkAllRead: _unreadCount > 0 ? _markAllRead : null,
        ),
        Expanded(
          child: _notifications.isEmpty
              ? const _EmptyNotifications()
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // ── Unread section ───────────────────────────────────────
                    if (_unread.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionLabel(
                          label: 'New',
                          count: _unread.length,
                          accentColor: AppColors.primaryAccent,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => _NotificationTile(
                            notification: _unread[i],
                            index: i,
                            onDismiss: () =>
                                _dismissNotification(_unread[i].id),
                          ),
                          childCount: _unread.length,
                        ),
                      ),
                    ],

                    // ── Read section ─────────────────────────────────────────
                    if (_read.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionLabel(
                          label: 'Earlier',
                          count: null,
                          accentColor: AppColors.textMuted,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => _NotificationTile(
                            notification: _read[i],
                            index: i + (_unread.length),
                            onDismiss: () => _dismissNotification(_read[i].id),
                          ),
                          childCount: _read.length,
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({
    required this.unreadCount,
    this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceTertiary,
              border: Border.all(color: AppColors.borderSubtle, width: 1.5),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.primaryAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                if (unreadCount > 0)
                  Text(
                    '$unreadCount unread',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  Text(
                    'All caught up',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (onMarkAllRead != null)
            AnimatedTap(
              onTap: onMarkAllRead!,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.accentSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryAccent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Mark all read',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.count,
    required this.accentColor,
  });

  final String label;
  final int? count;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: 1.2,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ),
          ],
          const SizedBox(width: 10),
          Expanded(
            child: Container(height: 1, color: AppColors.borderSubtle),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification Tile
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationTile extends StatefulWidget {
  const _NotificationTile({
    required this.notification,
    required this.index,
    required this.onDismiss,
  });

  final AppNotification notification;
  final int index;
  final VoidCallback onDismiss;

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final delay = widget.index * 50;
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );

    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _enterCtrl.forward();
    });
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  IconData get _typeIcon {
    switch (widget.notification.type) {
      case NotificationType.mention:
        return Icons.alternate_email_rounded;
      case NotificationType.system:
        return Icons.info_outline_rounded;
      case NotificationType.message:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.notification;
    final isUnread = !n.isRead;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Dismissible(
          key: Key(n.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => widget.onDismiss(),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            color: const Color(0xFF1A1A2E),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFFF6B6B),
              size: 22,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isUnread
                  ? AppColors.surfaceSecondary
                  : AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isUnread
                    ? AppColors.primaryAccent.withOpacity(0.18)
                    : AppColors.borderSubtle,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppAvatar(
                      initial: n.avatarInitial,
                      size: 44,
                      showGlow: isUnread,
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: isUnread
                              ? AppColors.primaryAccent
                              : AppColors.surfaceTertiary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundDark,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          _typeIcon,
                          size: 10,
                          color: isUnread
                              ? AppColors.backgroundDark
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.senderName,
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            n.formattedTime,
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: isUnread
                                  ? AppColors.primaryAccent
                                  : AppColors.textMuted,
                              fontWeight:
                                  isUnread ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n.message,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: isUnread
                              ? AppColors.textSecondary
                              : AppColors.textMuted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Unread dot
                if (isUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryAccent.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              color: AppColors.textMuted,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You're all caught up!",
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
