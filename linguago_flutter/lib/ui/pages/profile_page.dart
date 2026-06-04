import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/screens/achievement/achievement_screen.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  String _userName = 'User';
  String _uid = '...';

  @override
  void initState() {
    super.initState();
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      if (authData.user != null && mounted) {
        setState(() {
          _userName = authData.user!.name ?? authData.user!.username ?? 'User';
          _uid = authData.user!.id?.toString() ?? '...';
        });
      }
    } catch (e) {
      debugPrint("Error loading auth data: $e");
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

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
                const Icon(Icons.logout_rounded, size: 64, color: AppColors.primaryPurple),
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
                  'See you! Your learning progress, streaks, and achievements are safely saved.',
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
                    child: const Text(
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 120), // padding bottom for floating navbar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ──────────────────────────────────────────────────
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.disableBorder,
                    image: DecorationImage(
                      image: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : const NetworkImage('https://i.pinimg.com/736x/fc/b8/b6/fcb8b64a2f8c5c742f10b75a1ceb1139.jpg'), // placeholder portrait
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Name & UID ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _userName,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.copy_rounded,
                  size: 12, color: AppColors.secondaryText),
              const SizedBox(width: 4),
              Text(
                'UID : $_uid',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── Stats Row ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                      icon: '🌍',
                      label: 'World Level',
                      value: '12',
                      circleColor: const Color(0xFFE8F4F8))),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: '⚡',
                      label: 'XP',
                      value: '3804',
                      circleColor: const Color(0xFFFFF8E1))),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: '🏆',
                      label: 'Achievement',
                      value: '16',
                      circleColor: const Color(0xFFFFF3E0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AchievementScreen(),
                          ),
                        );
                      })),
            ],
          ),
          const SizedBox(height: 24),

          // ── Bio & Birthday Card ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoItem(title: 'warga solo', subtitle: 'Bio'),
                const Divider(height: 24, color: AppColors.backgroundSoft),
                _InfoItem(title: 'Nov 15', subtitle: 'Birthday'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Data Management ─────────────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Data Management',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ActionRow(title: 'Personal Data'),
          _ActionRow(title: 'Setting'),
          const SizedBox(height: 32),

          // ── Account ─────────────────────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ActionRow(
            title: 'Logout',
            textColor: Colors.red,
            hideChevron: true,
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color circleColor;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.circleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.fromLTRB(8, 36, 8, 16),
          width: double.infinity,
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
        ),
      ],
    ),
  );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String title;
  final Color textColor;
  final bool hideChevron;
  final VoidCallback? onTap;

  const _ActionRow({
    required this.title,
    this.textColor = AppColors.primaryText,
    this.hideChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            if (!hideChevron)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryText,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
