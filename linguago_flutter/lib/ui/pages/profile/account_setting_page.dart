import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/pages/profile/change_email_page.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';
import 'package:linguago_flutter/data/model/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  bool _isEditingUsername = false;
  bool _isEditingBio = false;

  late FocusNode _usernameFocusNode;
  late FocusNode _bioFocusNode;

  String _email = 'user@gmail.com';
  String _birthday = 'Nov 15';
  String _password = '********';
  final int _savedLessonsCount = 2; 

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'User');
    _bioController = TextEditingController(text: '');

    _usernameFocusNode = FocusNode();
    _bioFocusNode = FocusNode();

    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        setState(() {
          _isEditingUsername = false;
        });
        _saveUsername();
      }
    });

    _bioFocusNode.addListener(() {
      if (!_bioFocusNode.hasFocus) {
        setState(() {
          _isEditingBio = false;
        });
        _saveBio();
      }
    });

    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      if (authData.user != null && mounted) {
        final pref = await SharedPreferences.getInstance();
        final userId = authData.user!.id;
        final customBio = pref.getString('custom_bio_$userId');
        final customBirthday = pref.getString('custom_birthday_$userId');
        final currentUsername = authData.user!.name ?? authData.user!.username ?? 'User';

        setState(() {
          _usernameController.text = currentUsername;
          _email = authData.user!.email ?? 'user@gmail.com';
          
          if (customBio != null) {
            _bioController.text = customBio;
          } else {
            _bioController.text = (currentUsername == 'Potato_9595' || currentUsername == 'ikeufie' || currentUsername == 'hoonst4rs' || currentUsername == 'jung.jpeg')
                ? 'warga solo'
                : ''; 
          }

          if (customBirthday != null) {
            _birthday = customBirthday;
          } else {
            _birthday = (currentUsername == 'Potato_9595' || currentUsername == 'ikeufie' || currentUsername == 'hoonst4rs' || currentUsername == 'jung.jpeg')
                ? 'Nov 15'
                : ''; 
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading auth data: $e");
    }
  }

  Future<void> _saveUsername() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      if (authData.user != null) {
        final updatedUser = User(
          id: authData.user!.id,
          username: authData.user!.username,
          email: authData.user!.email,
          emailVerifiedAt: authData.user!.emailVerifiedAt,
          name: _usernameController.text.trim(),
          avatarUrl: authData.user!.avatarUrl,
          totalXp: authData.user!.totalXp,
          level: authData.user!.level,
          gems: authData.user!.gems,
          currentStreak: authData.user!.currentStreak,
          longestStreak: authData.user!.longestStreak,
          createdAt: authData.user!.createdAt,
          updatedAt: authData.user!.updatedAt,
        );
        final updatedAuthData = AuthResponseModel(
          user: updatedUser,
          token: authData.token,
        );
        await AuthLocalDatasource().saveAuthData(updatedAuthData);
      }
    } catch (e) {
      debugPrint("Error saving username: $e");
    }
  }

  Future<void> _saveBio() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      if (authData.user != null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setString('custom_bio_${authData.user!.id}', _bioController.text);
      }
    } catch (e) {
      debugPrint("Error saving bio: $e");
    }
  }

  Future<void> _saveBirthday() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      if (authData.user != null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setString('custom_birthday_${authData.user!.id}', _birthday);
      }
    } catch (e) {
      debugPrint("Error saving birthday: $e");
    }
  }

  void _handleLogout() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!'), backgroundColor: Colors.orangeAccent),
      );
    }
  }

  void _handleDeleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deletion requested.'), backgroundColor: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _usernameFocusNode.dispose();
    _bioFocusNode.dispose();
    super.dispose();
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
        title: const Text(
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
                onTap: _isEditingUsername
                    ? null
                    : () {
                        setState(() {
                          _isEditingUsername = true;
                        });
                        _usernameFocusNode.requestFocus();
                      },
                content: _isEditingUsername
                    ? TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (val) {
                          setState(() {
                            _isEditingUsername = false;
                          });
                          _saveUsername();
                        },
                      )
                    : Row(
                        children: [
                          Text(
                            _usernameController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            _buildCardItem(
              onTap: _isEditingBio
                  ? null
                  : () {
                      setState(() {
                        _isEditingBio = true;
                      });
                      _bioFocusNode.requestFocus();
                    },
              content: _isEditingBio
                  ? TextField(
                      controller: _bioController,
                      focusNode: _bioFocusNode,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (val) {
                        setState(() {
                          _isEditingBio = false;
                        });
                        _saveBio();
                      },
                    )
                  : Text(
                      _bioController.text.isEmpty ? 'Add Bio' : _bioController.text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _bioController.text.isEmpty ? AppColors.disableText : AppColors.primaryText,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            
            // ================= KELOMPOK UTAMA: SETTING (Sesuai Gambar) =================
            const Text(
              'Setting',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w700,
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
                  // 1. Menu Account
                  _buildSettingItem(
                    icon: Icons.person_rounded,
                    iconBgColor: const Color(0xFF9E86FF), // Warna ungu soft ikon Account
                    title: 'Account',
                    subtitle: 'Username, Bio, Email',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  
                  // 2. Menu Notification & Sound
                  _buildSettingItem(
                    icon: Icons.notifications_rounded,
                    iconBgColor: const Color(0xFFFFD466), // Warna kuning emas ikon Notif
                    title: 'Notification & Sound',
                    subtitle: 'Daily Goal, Study Reminder',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  
                  // 3. Menu Saved Lessons (Sekarang sudah masuk ke dalam kelompok grup ini)
                  _buildSettingItem(
                    icon: Icons.bookmark_rounded,
                    iconBgColor: const Color(0xFF66C2FF), // Warna biru soft ikon Saved Lessons
                    title: 'Saved Lessons',
                    subtitle: '$_savedLessonsCount Lessons Saved',
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedLessonsPage()));
                    },
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  
                  // 4. Menu Language
                  _buildSettingItem(
                    icon: Icons.g_translate_rounded,
                    iconBgColor: const Color(0xFFFF769F), // Warna pink soft ikon Language
                    title: 'Language',
                    subtitle: 'English, Indonesian',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= KELOMPOK PRIVASI DATA =================
            const Text(
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
                  _buildSettingItem(
                    icon: Icons.email_rounded,
                    iconBgColor: AppColors.primaryPurple,
                    title: _email,
                    subtitle: 'Email address',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChangeEmailPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildSettingItem(
                    icon: Icons.lock_rounded,
                    iconBgColor: AppColors.primaryPurple,
                    title: _password,
                    subtitle: 'Password',
                    onTap: _showChangePasswordBottomSheet,
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildSettingItem(
                    icon: Icons.cake_rounded,
                    iconBgColor: AppColors.primaryPurple,
                    title: _birthday,
                    subtitle: 'Birthday',
                    onTap: _selectBirthday,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= KELOMPOK UTILITIES BAWAH =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildActionRowItem(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: Colors.teal.shade300,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildActionRowItem(
                    icon: Icons.logout_rounded,
                    iconColor: Colors.redAccent.shade200,
                    title: 'Log Out',
                    onTap: _handleLogout,
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.backgroundSoft),
                  _buildActionRowItem(
                    icon: Icons.delete_outline_rounded,
                    iconColor: Colors.grey.shade600,
                    title: 'Delete Account',
                    onTap: _handleDeleteAccount,
                  ),
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
          style: const TextStyle(
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

  Widget _buildCardItem({required Widget content, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: content,
      ),
    );
  }

  Future<void> _selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010, 11, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPurple,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryText,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryPurple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      setState(() {
        _birthday = "${months[picked.month - 1]} ${picked.day}";
      });
      _saveBirthday();
    }
  }

  void _showChangePasswordBottomSheet() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.disableBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              _buildPasswordField('Current Password', currentPasswordController),
              const SizedBox(height: 12),
              _buildPasswordField('New Password', newPasswordController),
              const SizedBox(height: 12),
              _buildPasswordField('Confirm New Password', confirmPasswordController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (newPasswordController.text == confirmPasswordController.text && newPasswordController.text.isNotEmpty) {
                      setState(() {
                        _password = '*' * newPasswordController.text.length;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password updated successfully!'),
                          backgroundColor: AppColors.primaryPurple,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match or are empty.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save',
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
        );
      },
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.disableBorder),
          ),
          child: TextField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.disableText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRowItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
