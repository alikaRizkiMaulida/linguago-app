import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

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
          'Account',
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
            _buildFieldGroup(
              title: 'Your Username',
              child: _buildCardItem(
                content: Row(
                  children: [
                    Text(
                      'evan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('🎧♪.☆', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildCardItem(
              content: Text(
                'warga solo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Privacy Account',
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
                  _buildPrivacyItem(icon: Icons.email_rounded, title: 'evanganteng@gmail.com', subtitle: 'Email Address'),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildPrivacyItem(icon: Icons.lock_rounded, title: '********', subtitle: 'Password'),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildPrivacyItem(icon: Icons.cake_rounded, title: 'Nov 15', subtitle: 'Birthday'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldGroup({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildCardItem({required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    );
  }

  Widget _buildPrivacyItem({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.disableText, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
