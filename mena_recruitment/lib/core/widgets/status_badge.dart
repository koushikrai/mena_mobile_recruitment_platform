import 'package:flutter/material.dart';
import 'app_chip.dart'; // Reuse StatusType

/// Inline status badge/tag for card inline use.
class StatusBadge extends StatelessWidget {
  /// The label to display.
  final String label;

  /// The status type for styling.
  final StatusType statusType;

  /// Optional icon to display before the label.
  final IconData? icon;

  const StatusBadge({
    Key? key,
    required this.label,
    required this.statusType,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (statusType) {
      case StatusType.verified:
        bg = const Color(0xFFD1FAE5);
        text = const Color(0xFF059669); // Emerald
        break;
      case StatusType.pending:
      case StatusType.review:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFD97706); // Amber
        break;
      case StatusType.critical:
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFFDC2626); // Red
        break;
      case StatusType.info:
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF0F1E36); // Navy tint
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: text),
            const SizedBox(width: 4.0),
          ],
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
