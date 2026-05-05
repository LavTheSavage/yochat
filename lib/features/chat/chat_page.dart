import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/chat_models.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/message_input_bar.dart';

List<ChatMessage> _buildMockMessages(String conversationName) {
  final now = DateTime.now();
  return [
    ChatMessage(
      id: '1',
      text: 'Hey! How\'s it going?',
      isSent: false,
      timestamp: now.subtract(const Duration(minutes: 32)),
      isRead: true,
    ),
    ChatMessage(
      id: '2',
      text: 'Pretty good! Just finished the new design system 🎨',
      isSent: true,
      timestamp: now.subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      text: 'Oh nice, would love to see it!',
      isSent: false,
      timestamp: now.subtract(const Duration(minutes: 28)),
      isRead: true,
    ),
    ChatMessage(
      id: '4',
      text:
          'I\'ll share a preview shortly. It\'s very dark and premium looking.',
      isSent: true,
      timestamp: now.subtract(const Duration(minutes: 26)),
      isRead: true,
    ),
    ChatMessage(
      id: '5',
      text: 'Sounds amazing! Can\'t wait 🔥',
      isSent: false,
      timestamp: now.subtract(const Duration(minutes: 20)),
      isRead: true,
    ),
    ChatMessage(
      id: '6',
      text: 'Also, are we still on for the call later today?',
      isSent: false,
      timestamp: now.subtract(const Duration(minutes: 19)),
      isRead: true,
    ),
    ChatMessage(
      id: '7',
      text: 'Yes! 4PM works for me.',
      isSent: true,
      timestamp: now.subtract(const Duration(minutes: 15)),
      isRead: true,
    ),
    ChatMessage(
      id: '8',
      text: 'Perfect, see you then! 👋',
      isSent: false,
      timestamp: now.subtract(const Duration(minutes: 10)),
      isRead: true,
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Chat Page
// ─────────────────────────────────────────────────────────────────────────────

/// Full chat page with message list, input bar, and animations.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _inputFocusNode = FocusNode();
  late List<ChatMessage> _messages;
  bool _isTyping = false;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _messages = _buildMockMessages(widget.conversation.name);

    _messageController.addListener(() {
      final typing = _messageController.text.isNotEmpty;
      if (typing != _isTyping) setState(() => _isTyping = typing);
    });

    _scrollController.addListener(() {
      final atBottom = _scrollController.offset <=
          _scrollController.position.minScrollExtent + 80;
      if (!atBottom != _showScrollToBottom) {
        setState(() => _showScrollToBottom = !atBottom);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  // ── Scroll helpers ──────────────────────────────────────────────────────────

  void _scrollToBottom({bool animated = false}) {
    if (!_scrollController.hasClients) return;
    if (animated) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }

  // ── Send message ────────────────────────────────────────────────────────────

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isSent: true,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );
      _messageController.clear();
    });

    _scrollToBottom(animated: true);

    // Simulate received reply after short delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _simulateReply();
    });
  }

  void _simulateReply() {
    final replies = [
      'Got it! 👍',
      'Thanks for letting me know.',
      'Sounds great!',
      'I\'ll take a look.',
      'On it! 🚀',
    ];
    final reply = replies[Random().nextInt(replies.length)];

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: reply,
          isSent: false,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );
    });
    _scrollToBottom(animated: true);
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          // ── App Bar ────────────────────────────────────────────────────────
          ChatAppBar(conversation: widget.conversation),

          // ── Message List ───────────────────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isFirst = index == 0;
                    final showAvatar = !message.isSent &&
                        (index == _messages.length - 1 ||
                            _messages[index + 1].isSent);

                    return AnimatedChatBubble(
                      message: message,
                      showAvatar: showAvatar,
                      isNewest: isFirst,
                      avatarInitial: widget.conversation.avatarInitial,
                    );
                  },
                ),

                // Scroll to bottom FAB
                if (_showScrollToBottom)
                  Positioned(
                    bottom: 12,
                    right: 16,
                    child: AnimatedScale(
                      scale: _showScrollToBottom ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () => _scrollToBottom(animated: true),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.borderSubtle, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primaryAccent,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Input Bar ──────────────────────────────────────────────────────
          MessageInputBar(
            controller: _messageController,
            focusNode: _inputFocusNode,
            isTyping: _isTyping,
            onSend: _sendMessage,
            onAttach: () {},
          ),
        ],
      ),
    );
  }
}
