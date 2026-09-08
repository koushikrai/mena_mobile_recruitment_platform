import 'package:flutter/material.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({Key? key}) : super(key: key);

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
              'Security',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF990000),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Biometric Authentication'),
            value: true,
            onChanged: (val) {},
            secondary: const Icon(Icons.fingerprint),
          ),
          SwitchListTile(
            title: const Text('Two-Factor Auth (2FA)'),
            value: false,
            onChanged: (val) {},
            secondary: const Icon(Icons.security),
          ),
        ],
      ),
    );
  }
}
