import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_models.dart';
import 'package:chatapp/core/app_routes.dart';
import 'package:chatapp/core/app_theme.dart';
import 'package:chatapp/core/shared_widgets.dart';
import 'package:chatapp/features/auth/login_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  // Simulated logged-in user
  AppUser _user = const AppUser(
    id: 'me',
    name: 'Your Name',
    email: 'you@email.com',
    avatarInitial: 'Y',
    isDoNotDisturb: false,
  );

  late final AnimationController _enterCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _enterCtrl,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  void _toggleDnd(bool value) {
    HapticFeedback.selectionClick();
    setState(() => _user = _user.copyWith(isDoNotDisturb: value));
  }

  void _logout() {
    showDialog<void>(
      context: context,
      builder: (_) => _LogoutDialog(
        onConfirm: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.of(context).pushAndRemoveUntil(
            fadeRoute(const LoginPage()),
            (_) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          _MenuHeader(user: _user),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _ProfileCard(user: _user)),

                // ── Primary actions ──────────────────────────────────────────
                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                _MenuGroup(
                  items: [
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.people_outline_rounded,
                      label: 'Friends',
                      badge: '12',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.inventory_2_outlined,
                      label: 'Archive',
                      onTap: () {},
                    ),
                  ],
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // ── Help & Info ───────────────────────────────────────────────
                _MenuGroup(
                  items: [
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      label: 'About',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help',
                      onTap: () {},
                    ),
                  ],
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // ── Do Not Disturb + Logout ────────────────────────────────────
                _MenuGroup(
                  items: [
                    _DndMenuItem(
                      value: _user.isDoNotDisturb,
                      onChanged: _toggleDnd,
                    ),
                  ],
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                _MenuGroup(
                  items: [
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      isDestructive: true,
                      onTap: _logout,
                    ),
                  ],
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _MenuHeader extends StatelessWidget {
  const _MenuHeader({required this.user});
  final AppUser user;

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
          Text(
            'Menu',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          AnimatedTap(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceTertiary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Card
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            AppAvatar(
              initial: user.avatarInitial,
              size: 52,
              showGlow: true,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user.email,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryAccent.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Text(
                'Profile',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu Group (card container for grouped items)
// ─────────────────────────────────────────────────────────────────────────────

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
        ),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              items[i],
              if (i < items.length - 1)
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(left: 56),
                  color: AppColors.borderSubtle,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu Item
// ─────────────────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? const Color(0xFFFF6B6B) : AppColors.textSecondary;

    return AnimatedTap(
      onTap: onTap,
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFFF6B6B).withOpacity(0.1)
                    : AppColors.surfaceTertiary,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: isDestructive
                      ? const Color(0xFFFF6B6B).withOpacity(0.25)
                      : AppColors.borderSubtle,
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: isDestructive
                      ? const Color(0xFFFF6B6B)
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentSubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Do Not Disturb toggle item
// ─────────────────────────────────────────────────────────────────────────────

class _DndMenuItem extends StatelessWidget {
  const _DndMenuItem({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: value
                  ? const Color(0xFFFF6B6B).withOpacity(0.12)
                  : AppColors.surfaceTertiary,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: value
                    ? const Color(0xFFFF6B6B).withOpacity(0.3)
                    : AppColors.borderSubtle,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.do_not_disturb_on_outlined,
              color: value ? const Color(0xFFFF6B6B) : AppColors.textSecondary,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Do Not Disturb',
              style: GoogleFonts.dmSans(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryAccent,
              activeTrackColor: AppColors.primaryAccent.withOpacity(0.25),
              inactiveThumbColor: AppColors.textMuted,
              inactiveTrackColor: AppColors.surfaceTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logout Confirmation Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog({required this.onConfirm});
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF6B6B).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF6B6B),
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sign out?',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You'll need to sign in again to access your messages.",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AnimatedTap(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceTertiary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AnimatedTap(
                    onTap: onConfirm,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Out',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6B6B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
