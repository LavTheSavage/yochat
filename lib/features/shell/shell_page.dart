import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../menu/presentation/pages/menu_page.dart';
import '../widgets/shell_bottom_nav.dart';

/// Root shell that hosts the three bottom-nav destinations.
/// Keeps page state alive with [IndexedStack].
class ShellPage extends StatefulWidget {
  const ShellPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  late int _currentIndex;

  static const _pages = [
    HomeBody(),
    NotificationsPage(),
    MenuPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ShellBottomNav(
        selectedIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
