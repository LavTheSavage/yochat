import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/chat_models.dart';
import 'package:chatapp/core/app_routes.dart';
import 'package:chatapp/core/app_theme.dart';
import 'package:chatapp/core/shared_widgets.dart';
import 'package:chatapp/features/chat/chat_page.dart';
import 'package:chatapp/features/home/conversation_tile.dart';
import 'package:chatapp/features/home/filter_tab_bar.dart';
import 'package:chatapp/features/home/home_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mock Data
// ─────────────────────────────────────────────────────────────────────────────

final _mockConversations = [
  Conversation(
    id: '1',
    name: 'Alex Rivera',
    lastMessage: 'Hey! Are you free tomorrow?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 3,
    isOnline: true,
    avatarInitial: 'A',
  ),
  Conversation(
    id: '2',
    name: 'Jordan Kim',
    lastMessage: 'The design looks amazing 🔥',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 1,
    isOnline: true,
    avatarInitial: 'J',
    isFavorite: true,
  ),
  Conversation(
    id: '3',
    name: 'Priya Sharma',
    lastMessage: 'Let me check and get back to you',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    isOnline: false,
    avatarInitial: 'P',
  ),
  Conversation(
    id: '4',
    name: 'Marcus Chen',
    lastMessage: 'Done! Pushed the changes.',
    timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    unreadCount: 0,
    isOnline: false,
    avatarInitial: 'M',
    isFavorite: true,
  ),
  Conversation(
    id: '5',
    name: 'Sofia Nour',
    lastMessage: 'Can we reschedule the call?',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 5,
    isOnline: false,
    avatarInitial: 'S',
  ),
  Conversation(
    id: '6',
    name: 'Liam Torres',
    lastMessage: 'Sounds good, see you then!',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isOnline: true,
    avatarInitial: 'L',
  ),
  Conversation(
    id: '7',
    name: 'Yuki Tanaka',
    lastMessage: 'Thanks for the help 🙏',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isOnline: false,
    avatarInitial: 'Y',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// HomeBody — content-only, lives inside ShellPage's IndexedStack.
// ─────────────────────────────────────────────────────────────────────────────

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  late final AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listAnimController.dispose();
    super.dispose();
  }

  List<Conversation> get _filteredConversations {
    List<Conversation> list = _mockConversations;

    if (_searchQuery.isNotEmpty) {
      list = list
          .where((c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    switch (_selectedFilter) {
      case 1:
        list = list.where((c) => c.hasUnread).toList();
        break;
      case 2:
        list = list.where((c) => c.isFavorite).toList();
        break;
    }

    return list;
  }

  void _openChat(Conversation conversation) {
    Navigator.of(context).push(
      slideRoute(ChatPage(conversation: conversation)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredConversations;

    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: AppSearchBar(
                    controller: _searchController,
                    hintText: 'Search messages, people…',
                    onChanged: (q) => setState(() => _searchQuery = q),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: FilterTabBar(
                    selectedIndex: _selectedFilter,
                    onChanged: (i) => setState(() => _selectedFilter = i),
                    tabs: const ['All', 'Unread', 'Favorites'],
                    unreadCount:
                        _mockConversations.where((c) => c.hasUnread).length,
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  child: _EmptyState(filter: _selectedFilter),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final c = filtered[index];
                      return AnimatedConversationTile(
                        conversation: c,
                        index: index,
                        onTap: () => _openChat(c),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomePage — thin wrapper for standalone / deep-link use.
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: HomeBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});
  final int filter;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('💬', 'No conversations yet', 'Start a new chat to get going'),
      ('📭', 'All caught up!', 'No unread messages at the moment'),
      ('⭐', 'No favorites yet', 'Star a conversation to pin it here'),
    ];
    final (emoji, title, subtitle) = items[filter.clamp(0, 2)];

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
