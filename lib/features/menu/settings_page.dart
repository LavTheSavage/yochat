import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSecondary,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _settingTile(Icons.notifications_outlined, 'Notifications',
              'Sound, vibration, alerts'),
          _settingTile(Icons.lock_outline_rounded, 'Privacy & Security',
              'Blocked users, encryption'),
          _settingTile(
              Icons.storage_rounded, 'Data Usage', 'Network stats, storage'),
          _settingTile(
              Icons.palette_outlined, 'Appearance', 'Themes, wallpapers'),
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryAccent),
      title:
          Text(title, style: GoogleFonts.dmSans(color: AppColors.textPrimary)),
      subtitle: Text(subtitle,
          style: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 12)),
      trailing:
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: () {},
    );
  }
}
