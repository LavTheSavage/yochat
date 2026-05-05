// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:chatapp/core/app_theme.dart';
import 'package:chatapp/core/shared_widgets.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> friends = [
      {'name': 'Alex Johnson', 'status': 'Online', 'initial': 'A'},
      {'name': 'Sarah Smith', 'status': 'Offline', 'initial': 'S'},
      {'name': 'Mike Ross', 'status': 'Online', 'initial': 'M'},
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceSecondary,
      appBar: AppBar(title: const Text('Friends (12)')),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.surfaceTertiary,
              child: Text(friend['initial']!,
                  style: const TextStyle(color: AppColors.textPrimary)),
            ),
            title: Text(friend['name']!,
                style: const TextStyle(color: AppColors.textPrimary)),
            subtitle: Text(friend['status']!,
                style: TextStyle(
                    color: friend['status'] == 'Online'
                        ? Colors.green
                        : AppColors.textMuted)),
            trailing: const Icon(Icons.chat_bubble_outline, size: 20),
          );
        },
      ),
    );
  }
}
