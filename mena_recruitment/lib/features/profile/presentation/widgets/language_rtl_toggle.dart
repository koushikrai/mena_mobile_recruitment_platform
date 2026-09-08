import 'package:flutter/material.dart';

class LanguageRtlToggle extends StatelessWidget {
  const LanguageRtlToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: const Color(0xFFF8F9FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Language & Display',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0F1E36),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Arabic (RTL)'),
            value: false,
            onChanged: (val) {},
            secondary: const Icon(Icons.language),
          ),
        ],
      ),
    );
  }
}
