import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({super.key});

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  String _appLanguage = 'Indonesia';
  late String _learningLanguage;

  @override
  void initState() {
    super.initState();
    _learningLanguage = QuizProgress.learningLanguage;
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
          'Language',
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
              'App Language',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildRadioTile('English', _appLanguage == 'English', () => setState(() => _appLanguage = 'English')),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildRadioTile('Indonesia', _appLanguage == 'Indonesia', () => setState(() => _appLanguage = 'Indonesia')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Learning Language',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildRadioTile('English', _learningLanguage == 'English', () async {
                    setState(() => _learningLanguage = 'English');
                    final navigator = Navigator.of(context);
                    await QuizProgress.setLearningLanguage('English');
                    navigator.pushNamedAndRemoveUntil('/home', (route) => false);
                  }),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildRadioTile('Korea', _learningLanguage == 'Korea', () async {
                    setState(() => _learningLanguage = 'Korea');
                    final navigator = Navigator.of(context);
                    await QuizProgress.setLearningLanguage('Korea');
                    navigator.pushNamedAndRemoveUntil('/home', (route) => false);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.disableBorder,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
