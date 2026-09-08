import 'dart:ui';
import 'package:flutter/material.dart';

/// Frosted glass bottom navigation bar.
class BottomNavBar extends StatelessWidget {
  /// The current active index.
  final int currentIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTap;

  /// Optional counter badge for the Applications tab (index 1).
  final int applicationsBadgeCount;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.applicationsBadgeCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.0,
      decoration: const BoxDecoration(
        color: Colors.transparent, // Handled by BackdropFilter
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0), // Hairline
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(15, 30, 54, 0.05),
            offset: Offset(0, -4),
            blurRadius: 16,
          )
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: Colors.white.withOpacity(0.92),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'Jobs', Icons.work_outline, Icons.work),
                _buildNavItem(1, 'Applications', Icons.description_outlined, Icons.description, badgeCount: applicationsBadgeCount),
                _buildNavItem(2, 'Vault', Icons.shield_outlined, Icons.shield),
                _buildNavItem(3, 'Profile', Icons.person_outline, Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData inactiveIcon, IconData activeIcon, {int badgeCount = 0}) {
    final isActive = currentIndex == index;
    final color = isActive ? const Color(0xFF0F1E36) : const Color(0xFF64748B);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned(
                top: 0,
                child: Container(
                  width: 32,
                  height: 2,
                  color: const Color(0xFF0F1E36),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(isActive ? activeIcon : inactiveIcon, color: color, size: 24),
                    if (badgeCount > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDC2626), // Red for badge
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            badgeCount > 9 ? '9+' : badgeCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
