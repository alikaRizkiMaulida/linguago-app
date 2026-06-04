import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/pages/course_page.dart';
import 'package:linguago_flutter/ui/pages/home_page.dart';
import 'package:linguago_flutter/ui/pages/profile_page.dart';
import 'package:linguago_flutter/ui/pages/setting_page.dart';
import 'package:linguago_flutter/ui/screens/leaderboard/leaderboard_screen.dart';
import 'package:linguago_flutter/ui/widgets/bottom_navbar.dart';

/// HomeScreen — Shell utama yang memegang bottom nav dan tab pages.
/// Isi setiap tab ada di folder pages/.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

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
                HomePage(),
                const CoursePage(),
                const LeaderboardScreen(),
                SettingPage(),
                ProfilePage(),
              ],
            ),
            // Floating Bottom Navbar
            Positioned(
              left: 20,
              right: 20,
              bottom: 24, // floating above bottom
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


