import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';


class FriendAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final bool isOnline;
  final double size;
  final VoidCallback? onTap;

  const FriendAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.isOnline = false,
    this.size = 48,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildInitials(),
                        )
                      : _buildInitials(),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          if (name.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              name.split(' ').first,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildInitials() {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join()
        : '?';
    return Container(
      color: AppColors.backgroundAlt,
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class FriendAvatarRow extends StatelessWidget {
  final List<Map<String, dynamic>> friends;
  final VoidCallback? onSeeAll;

  const FriendAvatarRow({
    super.key,
    required this.friends,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...friends.take(5).map(
              (f) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FriendAvatar(
                  name: f['name'] ?? '',
                  imageUrl: f['imageUrl'],
                  isOnline: f['isOnline'] ?? false,
                ),
              ),
            ),
        if (friends.length > 5)
          GestureDetector(
            onTap: onSeeAll,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.backgroundSoft,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.disableBorder, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '+${friends.length - 5}',
                  style: const TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}