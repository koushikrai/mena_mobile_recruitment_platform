import 'package:flutter/material.dart';

class AvailabilityToggle extends StatelessWidget {
  final bool isActivelyLooking;
  final ValueChanged<bool> onChanged;

  const AvailabilityToggle({
    Key? key,
    required this.isActivelyLooking,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF8F9FF),
      elevation: 0,
      child: SwitchListTile(
        title: const Text(
          'Actively Seeking GCC Relocation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
        ),
        subtitle: const Text('Recruiters can find your profile'),
        value: isActivelyLooking,
        onChanged: onChanged,
        activeColor: const Color(0xFF059669),
      ),
    );
  }
}
