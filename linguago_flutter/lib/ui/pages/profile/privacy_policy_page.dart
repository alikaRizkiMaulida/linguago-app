import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Police',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Linguago collects only the information needed to support its learning features, such as profile details, course progress, quiz results, streaks, XP, badges, leaderboard details, and listening practice history. We may also collect non-personal device information to improve app performance and user experience.\n\n'
              'Your data is used only to provide personalized learning progress, track achievements, display leaderboard rankings, and improve the overall learning experience. Linguago does not sell or share your personal information with third parties. If analytics or crash reporting tools are used, they only receive anonymous usage data.\n\n'
              'You can view, edit, or delete your account information and learning progress at any time. Some optional permissions, such as notifications or microphone access for listening activities, may be requested to enhance certain features but are not required for basic app usage.\n\n'
              'Linguago is designed as an educational app for learning English and Korean through courses, quizzes, fun facts, community features, rewards, and interactive listening exercises. We may update this Privacy Policy from time to time, and the latest version will always be available in the app.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryText,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
