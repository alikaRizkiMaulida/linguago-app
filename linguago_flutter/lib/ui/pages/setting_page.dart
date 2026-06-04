import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/pages/account_setting_page.dart';
import 'package:linguago_flutter/ui/pages/notification_setting_page.dart';
import 'package:linguago_flutter/ui/pages/language_setting_page.dart';
import 'package:linguago_flutter/ui/pages/privacy_policy_page.dart';
import 'package:linguago_flutter/ui/pages/delete_account_page.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Mascot Mascot.png', height: 100, errorBuilder: (context, error, stackTrace) => const Icon(Icons.sentiment_dissatisfied_rounded, size: 64, color: AppColors.primaryPurple)),
                const SizedBox(height: 16),
                Text(
                  'You\'ll be logged out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'See you! Your learning progress, streaks, and achievements are safely saved in Linguago.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      AuthLocalDatasource().removeAuthData().then((_) {
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Mascot Mascot.png', height: 100, errorBuilder: (context, error, stackTrace) => const Icon(Icons.sentiment_dissatisfied_rounded, size: 64, color: AppColors.primaryPurple)),
                const SizedBox(height: 16),
                Text(
                  'Leaving Linguago?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your account and learning progress will be permanently deleted from Linguago ⚠️',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DeleteAccountPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.disableBorder,
              image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/736x/fc/b8/b6/fcb8b64a2f8c5c742f10b75a1ceb1139.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'evan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(width: 6),
              const Text('🎧♪.☆', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          // UID
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.copy_rounded, size: 12, color: AppColors.secondaryText),
              const SizedBox(width: 4),
              Text(
                'UID : 1009012',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Card 1
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _SettingMenuTile(
                  icon: Icons.person_rounded,
                  iconColor: AppColors.primaryPurple,
                  iconBgColor: AppColors.primaryPurple.withOpacity(0.1),
                  title: 'Account',
                  subtitle: 'Username, Bio, Email',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingPage()));
                  },
                ),
                const Divider(height: 1, color: AppColors.backgroundSoft, indent: 64, endIndent: 20),
                _SettingMenuTile(
                  icon: Icons.notifications_rounded,
                  iconColor: Colors.orange,
                  iconBgColor: Colors.orange.withOpacity(0.1),
                  title: 'Notification & Sound',
                  subtitle: 'Daily Goal, Study Reminder',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingPage()));
                  },
                ),
                const Divider(height: 1, color: AppColors.backgroundSoft, indent: 64, endIndent: 20),
                _SettingMenuTile(
                  icon: Icons.translate_rounded,
                  iconColor: Colors.pinkAccent,
                  iconBgColor: Colors.pinkAccent.withOpacity(0.1),
                  title: 'Language',
                  subtitle: 'English, Indonesian',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSettingPage()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Card 2
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _SettingMenuTile(
                  icon: Icons.verified_user_rounded, // Privacy shield/check
                  iconColor: Colors.teal,
                  iconBgColor: Colors.teal.withOpacity(0.1),
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()));
                  },
                ),
                const Divider(height: 1, color: AppColors.backgroundSoft, indent: 64, endIndent: 20),
                _SettingMenuTile(
                  icon: Icons.logout_rounded,
                  iconColor: Colors.red,
                  iconBgColor: Colors.red.withOpacity(0.1),
                  title: 'Log Out',
                  titleColor: Colors.red,
                  hideChevron: true,
                  onTap: () => _showLogoutDialog(context),
                ),
                const Divider(height: 1, color: AppColors.backgroundSoft, indent: 64, endIndent: 20),
                _SettingMenuTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: Colors.grey,
                  iconBgColor: Colors.grey.withOpacity(0.1),
                  title: 'Delete Account',
                  titleColor: Colors.grey,
                  hideChevron: true,
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingMenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final bool hideChevron;
  final VoidCallback onTap;

  const _SettingMenuTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.hideChevron = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor ?? AppColors.primaryText,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!hideChevron)
              const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText, size: 20),
          ],
        ),
      ),
    );
  }
}
