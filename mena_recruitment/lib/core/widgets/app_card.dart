import 'package:flutter/material.dart';

/// Elevated card matching the design system.
class AppCard extends StatelessWidget {
  /// The content of the card.
  final Widget child;

  /// Optional callback when the card is tapped.
  final VoidCallback? onTap;

  /// Whether the card is in a selected state. Upgrades shadow and border.
  final bool isSelected;

  /// Padding inside the card. Defaults to 16px.
  final EdgeInsetsGeometry padding;

  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0);
    
    // Level 1 shadow by default, Level 2 if selected
    final List<BoxShadow> shadows = isSelected
        ? [
            const BoxShadow(
              color: Color.fromRGBO(15, 30, 54, 0.06),
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
            const BoxShadow(
              color: Color.fromRGBO(15, 30, 54, 0.04),
              offset: Offset(0, 10),
              blurRadius: 15,
            ),
          ]
        : [
            const BoxShadow(
              color: Color.fromRGBO(15, 30, 54, 0.04),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
            const BoxShadow(
              color: Color.fromRGBO(15, 30, 54, 0.02),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ];

    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: shadows,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
