import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_theme.dart';

/// Premium message input bar with animated send button.
class MessageInputBar extends StatelessWidget {
  const MessageInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isTyping,
    required this.onSend,
    required this.onAttach,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTyping;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(12, 10, 12, bottomPadding + 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: const Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Attach Button ────────────────────────────────────────────────
          _InputAction(
            icon: Icons.add_rounded,
            onTap: onAttach,
            tooltip: 'Attach',
          ),

          const SizedBox(width: 8),

          // ── Text Field ───────────────────────────────────────────────────
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 44, maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.surfaceTertiary,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isTyping
                      ? AppColors.primaryAccent.withOpacity(0.35)
                      : AppColors.borderSubtle,
                  width: 1,
                ),
                boxShadow: isTyping
                    ? [
                        BoxShadow(
                          color: AppColors.accentGlow,
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.dmSans(
                  fontSize: 14.5,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  hintText: 'Send a message…',
                  hintStyle: GoogleFonts.dmSans(
                    fontSize: 14.5,
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: _EmojiButton(onTap: () {}),
                ),
                cursorColor: AppColors.primaryAccent,
                cursorWidth: 2,
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── Send / Mic Button ────────────────────────────────────────────
          AnimatedSendButton(isTyping: isTyping, onSend: onSend),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated Send Button
// ─────────────────────────────────────────────────────────────────────────────

class AnimatedSendButton extends StatelessWidget {
  const AnimatedSendButton({
    super.key,
    required this.isTyping,
    required this.onSend,
  });

  final bool isTyping;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isTyping ? AppColors.primaryAccent : AppColors.surfaceTertiary,
          border: Border.all(
            color: isTyping ? AppColors.primaryAccent : AppColors.borderSubtle,
            width: 1,
          ),
          boxShadow: isTyping
              ? [
                  BoxShadow(
                    color: AppColors.primaryAccent.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: RotationTransition(
              turns: Tween<double>(begin: 0.15, end: 0).animate(anim),
              child: child,
            ),
          ),
          child: Icon(
            isTyping ? Icons.send_rounded : Icons.mic_rounded,
            key: ValueKey(isTyping),
            color: isTyping ? AppColors.backgroundDark : AppColors.textMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting widgets
// ─────────────────────────────────────────────────────────────────────────────

class _InputAction extends StatelessWidget {
  const _InputAction({
    required this.icon,
    required this.onTap,
    this.tooltip = '',
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceTertiary,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderSubtle, width: 1),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 22),
        ),
      ),
    );
  }
}

class _EmojiButton extends StatelessWidget {
  const _EmojiButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Icon(
          Icons.sentiment_satisfied_alt_rounded,
          color: AppColors.textMuted,
          size: 22,
        ),
      ),
    );
  }
}
