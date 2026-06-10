import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/chat_store.dart';
import 'package:linguago_flutter/ui/pages/chat_page.dart';
import 'package:linguago_flutter/ui/pages/course_page.dart';
import 'package:linguago_flutter/ui/pages/home_page.dart';
import 'package:linguago_flutter/ui/pages/profile_page.dart';
import 'package:linguago_flutter/ui/screens/leaderboard/leaderboard_screen.dart';
import 'package:linguago_flutter/ui/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';

/// HomeScreen — Shell utama yang memegang bottom nav dan tab pages.
/// Isi setiap tab ada di folder pages/.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  bool _showPill = false;
  String _pillSender = '';
  String _pillMessage = '';
  Timer? _pillTimer;
  ChatConversation? _lastConversation;

  @override
  void initState() {
    super.initState();
    ChatStore.instance.onNewMessage = _handleNewMessage;
    QuizProgress.onDailyGoalCompleted = _handleDailyGoalCompleted;
  }

  @override
  void dispose() {
    ChatStore.instance.onNewMessage = null;
    QuizProgress.onDailyGoalCompleted = null;
    _pillTimer?.cancel();
    super.dispose();
  }

  void _handleDailyGoalCompleted() {
    SharedPreferences.getInstance().then((prefs) {
      final enabled = prefs.getBool('daily_goal_notification') ?? true;
      if (!enabled || !mounted) return;

      setState(() {
        _pillSender = 'Daily Goal';
        _pillMessage = 'Completed today\'s goal! 🎯 (+50 XP)';
        _lastConversation = null;
        _showPill = true;
      });

      _pillTimer?.cancel();
      _pillTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _showPill = false;
          });
        }
      });
    });
  }

  void _handleNewMessage() {
    SharedPreferences.getInstance().then((prefs) {
      final enabled = prefs.getBool('chat_notification') ?? true;
      if (!enabled || !mounted) return;
      final last = ChatStore.instance.conversations.isNotEmpty
          ? ChatStore.instance.conversations.first
          : null;
      if (last == null) return;
      
      setState(() {
        _pillSender = last.friendName;
        _pillMessage = last.lastMessage;
        _lastConversation = last;
        _showPill = true;
      });

      _pillTimer?.cancel();
      _pillTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _showPill = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Konten Tab
            IndexedStack(
              index: _tabIndex,
              children: const [
                HomePage(),          // 0 - Home
                CoursePage(),        // 1 - Course
                LeaderboardScreen(), // 2 - Rank
                ChatPage(),          // 3 - Chat
                ProfilePage(),       // 4 - Profile
              ],
            ),
            // Floating Bottom Navbar
            Positioned(
              left: 20,
              right: 20,
              bottom: 24, // floating above bottom
              child: BottomNavbar(
                currentIndex: _tabIndex,
                onTap: (index) {
                  setState(() {
                    _tabIndex = index;
                    if (index == 3) {
                      for (final c in ChatStore.instance.conversations) {
                        c.unread = 0;
                      }
                      ChatStore.instance.notifyListeners();
                    }
                  });
                },
              ),
            ),
            // Floating Notification Pill
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              top: _showPill ? 12.0 : -80.0,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showPill ? 1.0 : 0.0,
                  child: GestureDetector(
                    onTap: () {
                      if (_lastConversation == null) {
                        setState(() {
                          _showPill = false;
                          _tabIndex = 4; // Switch to Profile/Achievements tab
                        });
                        return;
                      }
                      setState(() {
                        _showPill = false;
                        _tabIndex = 3; // Switch to Chat tab
                      });
                      ChatStore.instance.markRead(_lastConversation!.friendName);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ChatDetailPage(
                            friendName: _lastConversation!.friendName,
                            friendAvatarUrl: _lastConversation!.friendAvatarUrl,
                            avatarColor: _lastConversation!.avatarColor,
                            initial: _lastConversation!.initial,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryPurple,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/fluent_chat-28-filled.svg',
                              width: 12,
                              height: 12,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _pillSender,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _pillMessage,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
