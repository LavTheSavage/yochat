import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSecondary,
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const FlutterLogo(size: 80),
            const SizedBox(height: 20),
            Text('ChatApp v1.0.4',
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            const Text('A modern communication platform built with Flutter.',
                textAlign: TextAlign.center),
            const Spacer(),
            const Text('© 2024 ChatApp Inc.',
                style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

// --- Help Page ---
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSecondary,
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(title: Text('How to reset password?'), children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: Text('Go to Login > Forgot Password.'))
          ]),
          ExpansionTile(title: Text('Is my data encrypted?'), children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: Text('Yes, we use end-to-end encryption.'))
          ]),
          ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text('Contact Support')),
        ],
      ),
    );
  }
}
