import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_theme.dart';
import 'package:chatapp/core/shared_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSecondary,
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surfaceSecondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppAvatar(initial: 'Y', size: 100, showGlow: true),
            const SizedBox(height: 16),
            Text('Your Name',
                style: GoogleFonts.dmSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            Text('you@email.com',
                style: GoogleFonts.dmSans(color: AppColors.textMuted)),
            const SizedBox(height: 24),
            _buildStatRow(),
            const SizedBox(height: 32),
            _buildInfoTile('Bio',
                'Flutter Developer & UI Enthusiast. Loving the dark mode vibes.'),
            _buildInfoTile('Location', 'San Francisco, CA'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statColumn('Posts', '128'),
        _statColumn('Followers', '1.2k'),
        _statColumn('Following', '450'),
      ],
    );
  }

  Widget _statColumn(String label, String count) {
    return Column(
      children: [
        Text(count,
            style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        Text(label,
            style:
                GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.dmSans(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
