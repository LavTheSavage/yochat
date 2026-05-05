import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatapp/core/app_theme.dart';
import 'package:chatapp/features/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.backgroundDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // App starts at Login; after auth it navigates to ShellPage.
      home: const LoginPage(),
    );
  }
}
