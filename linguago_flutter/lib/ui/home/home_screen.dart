import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/language_preference.dart';
import 'package:linguago_flutter/ui/chat/pages/chat_list_page.dart';
import 'package:linguago_flutter/ui/pages/course_page.dart';
import 'package:linguago_flutter/ui/pages/english_course_page.dart';
import 'package:linguago_flutter/ui/pages/home_page.dart';
import 'package:linguago_flutter/ui/pages/profile_page.dart';
import 'package:linguago_flutter/ui/screens/leaderboard/leaderboard_screen.dart';
import 'package:linguago_flutter/ui/widgets/bottom_navbar.dart';

/// HomeScreen — Shell utama yang memegang bottom nav dan tab pages.
/// Isi setiap tab ada di folder pages/.
/// Course tab switch otomatis antara Korean (CoursePage) dan English
/// (EnglishCoursePage) berdasarkan LanguagePreference.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Rebuild whenever learning language changes (English ↔ Korean)
    LanguagePreference.learningLanguage.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LanguagePreference.learningLanguage.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bool isKorean =
        LanguagePreference.learningLanguage.value == 'Korean';

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Konten Tab
            IndexedStack(
              index: _tabIndex,
              children: [
                const HomePage(),           // 0 - Home (reactive by itself)
                isKorean                    // 1 - Course
                    ? const CoursePage()
                    : const EnglishCoursePage(),
                const LeaderboardScreen(),  // 2 - Rank
                const ChatListPage(),           // 3 - Chat
                const ProfilePage(),        // 4 - Profile
              ],
            ),
            // Floating Bottom Navbar
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: BottomNavbar(
                currentIndex: _tabIndex,
                onTap: (index) => setState(() => _tabIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
