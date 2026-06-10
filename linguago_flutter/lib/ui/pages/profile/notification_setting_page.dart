import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool _dailyGoal = true;
  bool _studyReminder = true;
  bool _chatMessage = true;
  bool _soundEffect = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal = prefs.getBool('daily_goal_notification') ?? true;
      _chatMessage = prefs.getBool('chat_notification') ?? true;
      _studyReminder = prefs.getBool('study_reminder_notification') ?? true;
      _soundEffect = prefs.getBool('sound_effect_notification') ?? true;
    });
  }

  Future<void> _setDailyGoalNotif(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_goal_notification', v);
    setState(() => _dailyGoal = v);
  }

  Future<void> _setChatNotif(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chat_notification', v);
    setState(() => _chatMessage = v);
  }

  Future<void> _setStudyReminderNotif(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('study_reminder_notification', v);
    setState(() => _studyReminder = v);
  }

  Future<void> _setSoundEffectNotif(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_effect_notification', v);
    setState(() => _soundEffect = v);
  }

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
          'Notification & Sound',
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSwitchTile('Daily Goal', _dailyGoal, _setDailyGoalNotif),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildSwitchTile('Study Reminder', _studyReminder, _setStudyReminderNotif),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildSwitchTile('Chat Messages', _chatMessage, _setChatNotif),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Sound',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSwitchTile('Sound Effect', _soundEffect, _setSoundEffectNotif),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: SizedBox(
              width: 78,
              height: 31,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 12.11,
                    top: 4.11,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: value
                            ? AppColors.secondary
                            : const Color(0xFFC9C6CF),
                      ),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: value ? 26.0 : 0.0),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    builder: (context, offset, child) {
                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: SvgPicture.asset(
                          'assets/bat_mascot.svg',
                          width: 78,
                          height: 31,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
