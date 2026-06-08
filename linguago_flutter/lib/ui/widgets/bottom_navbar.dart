import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Using standard Material Icons that closely match the screenshot
  static const List<_NavItem> _items = [
    _NavItem(
      svgAsset: 'assets/material-symbols_home-rounded.svg',
      label: 'Home',
    ),
    _NavItem(
      svgAsset: 'assets/material-symbols_book-6-rounded.svg',
      label: 'Course',
    ),
    _NavItem(
      svgAsset: 'assets/game-icons_achievement.svg',
      label: 'Rank',
    ),
    _NavItem(
      svgAsset: 'assets/fluent_chat-28-filled.svg',
      label: 'Chat',
    ),
    _NavItem(
      svgAsset: 'assets/gg_profile.svg',
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64, // Slightly shorter for floating pill
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(40), // Fully rounded pill
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Evenly spaced
        children: List.generate(
          _items.length,
          (index) => _NavBarItem(
            item: _items[index],
            isActive: currentIndex == index,
            onTap: () => onTap(index),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String svgAsset;
  final String label;

  const _NavItem({
    required this.svgAsset,
    required this.label,
  });
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 18 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFCBB8F0) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              item.svgAsset,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryPurple,
                BlendMode.srcIn,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: 
                  FontWeight.w700,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}