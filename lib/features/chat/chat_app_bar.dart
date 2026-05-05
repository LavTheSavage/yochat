import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/chat_models.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';

/// Custom app bar for the chat screen.
class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key, required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(8, topPadding + 8, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Back Button ────────────────────────────────────────────────────
          AnimatedTap(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceTertiary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ── Avatar ─────────────────────────────────────────────────────────
          AppAvatar(
            initial: conversation.avatarInitial,
            size: 40,
            isOnline: conversation.isOnline,
            showGlow: conversation.isOnline,
          ),

          const SizedBox(width: 10),

          // ── Name & Status ──────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (conversation.isOnline) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.onlineGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      conversation.isOnline ? 'Online now' : 'Last seen recently',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: conversation.isOnline
                            ? AppColors.onlineGreen
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Action Buttons ─────────────────────────────────────────────────
          _AppBarAction(icon: Icons.call_rounded, onTap: () {}),
          const SizedBox(width: 8),
          _AppBarAction(icon: Icons.videocam_rounded, onTap: () {}),
          const SizedBox(width: 8),
          _AppBarAction(icon: Icons.more_vert_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _AppBarAction extends StatelessWidget {
  const _AppBarAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceTertiary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 18),
      ),
    );
  }
}
