import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/chat_models.dart';
import 'package:chatapp/core/app_theme.dart';
import 'package:chatapp/core/shared_widgets.dart';

class AnimatedChatBubble extends StatefulWidget {
  const AnimatedChatBubble({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.isNewest,
    required this.avatarInitial,
  });

  final ChatMessage message;
  final bool showAvatar;
  final bool isNewest;
  final String avatarInitial;

  @override
  State<AnimatedChatBubble> createState() => _AnimatedChatBubbleState();
}

class _AnimatedChatBubbleState extends State<AnimatedChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
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
      child: ScaleTransition(
        scale: _scale,
        alignment: widget.message.isSent
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _ChatBubble(
          message: widget.message,
          showAvatar: widget.showAvatar,
          avatarInitial: widget.avatarInitial,
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.showAvatar,
    required this.avatarInitial,
  });

  final ChatMessage message;
  final bool showAvatar;
  final String avatarInitial;

  @override
  Widget build(BuildContext context) {
    final isSent = message.isSent;

    return Padding(
      padding: EdgeInsets.only(
        top: 3,
        bottom: 3,
        left: isSent ? 60 : 0,
        right: isSent ? 0 : 60,
      ),
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Received avatar ─────────────────────────────────────────────
          if (!isSent) ...[
            if (showAvatar)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 2),
                child: AppAvatar(
                  initial: avatarInitial,
                  size: 28,
                ),
              )
            else
              const SizedBox(width: 36),
          ],

          // ── Bubble ──────────────────────────────────────────────────────
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSent
                        ? AppColors.sentBubble
                        : AppColors.receivedBubble,
                    borderRadius: _bubbleRadius(isSent),
                    boxShadow: [
                      BoxShadow(
                        color: isSent
                            ? AppColors.primaryAccent.withOpacity(0.08)
                            : Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: isSent
                          ? AppColors.primaryAccent.withOpacity(0.15)
                          : AppColors.borderSubtle,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.dmSans(
                      fontSize: 14.5,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),

                // ── Timestamp + read receipt ─────────────────────────────
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.formattedTime,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (isSent) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.isRead
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 13,
                        color: message.isRead
                            ? AppColors.primaryAccent
                            : AppColors.textMuted,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ── Sent avatar placeholder (spacing) ───────────────────────────
          if (isSent) const SizedBox(width: 4),
        ],
      ),
    );
  }

  BorderRadius _bubbleRadius(bool isSent) {
    const radius = 18.0;
    const smallRadius = 5.0;
    return isSent
        ? const BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(smallRadius),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(smallRadius),
            bottomRight: Radius.circular(radius),
          );
  }
}
