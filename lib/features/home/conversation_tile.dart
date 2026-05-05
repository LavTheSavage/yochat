import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/chat_models.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';

/// Animated conversation tile for the home list.
class AnimatedConversationTile extends StatefulWidget {
  const AnimatedConversationTile({
    super.key,
    required this.conversation,
    required this.index,
    required this.onTap,
  });

  final Conversation conversation;
  final int index;
  final VoidCallback onTap;

  @override
  State<AnimatedConversationTile> createState() =>
      _AnimatedConversationTileState();
}

class _AnimatedConversationTileState extends State<AnimatedConversationTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    // Staggered entrance animation based on list index
    final delay = widget.index * 60;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _ConversationTile(
          conversation: widget.conversation,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      borderRadius: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────────────
            AppAvatar(
              initial: conversation.avatarInitial,
              size: 50,
              isOnline: conversation.isOnline,
              showGlow: conversation.hasUnread,
            ),

            const SizedBox(width: 14),

            // ── Content ─────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: conversation.hasUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conversation.formattedTime,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: conversation.hasUnread
                              ? AppColors.primaryAccent
                              : AppColors.textMuted,
                          fontWeight: conversation.hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: conversation.hasUnread
                                ? AppColors.textSecondary
                                : AppColors.textMuted,
                            fontWeight: conversation.hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          constraints: const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primaryAccent.withOpacity(0.4),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              conversation.unreadCount > 99
                                  ? '99+'
                                  : '${conversation.unreadCount}',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.backgroundDark,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
