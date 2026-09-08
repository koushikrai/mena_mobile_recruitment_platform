import 'package:flutter/material.dart';

/// A widget that displays a GCC country flag.
class CountryFlag extends StatelessWidget {
  /// The ISO country code (e.g., UAE, SAU, QAT, KWT, OMN, BHR).
  final String countryCode;

  /// Whether to display a larger size with a country name label.
  final bool showLabel;

  /// Size of the flag (ignored if [showLabel] is true, as it uses a preset larger size).
  final double width;
  final double height;

  const CountryFlag({
    Key? key,
    required this.countryCode,
    this.showLabel = false,
    this.width = 24.0,
    this.height = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flagWidth = showLabel ? 32.0 : width;
    final flagHeight = showLabel ? 24.0 : height;

    final flagImage = ClipRRect(
      borderRadius: BorderRadius.circular(4.0), // Rounded rect as per standard, small radius
      child: Image.asset(
        'assets/images/flags/${countryCode.toLowerCase()}.png',
        width: flagWidth,
        height: flagHeight,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: flagWidth,
          height: flagHeight,
          color: const Color(0xFFE2E8F0),
          child: const Icon(Icons.flag, size: 12, color: Colors.grey),
        ),
      ),
    );

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          flagImage,
          const SizedBox(width: 8),
          Text(
            countryCode.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1E36),
            ),
          ),
        ],
      );
    }

    return flagImage;
  }
}
