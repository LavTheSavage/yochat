import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_theme.dart';

/// Animated pill-style filter tab bar.
class FilterTabBar extends StatelessWidget {
  const FilterTabBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.tabs,
    this.unreadCount = 0,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> tabs;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = selectedIndex == index;
        // Show badge on 'Unread' tab (index 1)
        final showBadge = index == 1 && unreadCount > 0;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryAccent.withOpacity(0.15)
                    : AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryAccent.withOpacity(0.5)
                      : AppColors.borderSubtle,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primaryAccent
                          : AppColors.textSecondary,
                    ),
                    child: Text(tabs[index]),
                  ),
                  if (showBadge) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.unreadBadge,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.backgroundDark,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
