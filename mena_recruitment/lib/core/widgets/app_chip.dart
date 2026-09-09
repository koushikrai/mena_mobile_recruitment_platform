import 'package:flutter/material.dart';

/// Enum defining the standard status types.
enum StatusType { verified, review, critical, info, pending }

/// Status chip/pill widget with a full pill radius.
class AppChip extends StatelessWidget {
  /// The label text of the chip.
  final String label;

  /// The predefined status type, which dictates colors.
  final StatusType? statusType;

  /// Custom background color if [statusType] is not provided.
  final Color? backgroundColor;

  /// Custom text color if [statusType] is not provided.
  final Color? textColor;

  /// Custom border color if [statusType] is not provided.
  final Color? borderColor;

  /// Optional leading icon.
  final Widget? leadingIcon;

  const AppChip({
    super.key,
    required this.label,
    this.statusType,
    this.backgroundColor,
    Color? textColor,
    Color? labelColor,
    this.borderColor,
    Widget? leadingIcon,
    Widget? icon,
  })  : textColor = textColor ?? labelColor,
        leadingIcon = leadingIcon ?? icon;

  @override
  Widget build(BuildContext context) {
    Color bg = backgroundColor ?? Colors.transparent;
    Color text = textColor ?? Colors.black;
    Color border = borderColor ?? Colors.transparent;

    if (statusType != null) {
      switch (statusType!) {
        case StatusType.verified:
          bg = const Color(0xFFD1FAE5);
          text = const Color(0xFF065F46); // Emerald dark
          border = const Color(0xFF34D399); // Emerald border
          break;
        case StatusType.review:
        case StatusType.pending:
          bg = const Color(0xFFFEF3C7);
          text = const Color(0xFF92400E); // Amber dark
          border = const Color(0xFFFBBF24); // Amber border
          break;
        case StatusType.critical:
          bg = const Color(0xFFFEE2E2);
          text = const Color(0xFF991B1B); // Red dark
          border = const Color(0xFFF87171); // Red border
          break;
        case StatusType.info:
          bg = const Color(0xFFE0E7FF);
          text = const Color(0xFF3730A3); // Indigo/Navy dark
          border = const Color(0xFF818CF8);
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999.0), // Full pill
        border: Border.all(color: border, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            IconTheme(
              data: IconThemeData(color: text, size: 14),
              child: leadingIcon!,
            ),
            const SizedBox(width: 4.0),
          ],
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
