import 'package:flutter/material.dart';

class NotificationSettings extends StatelessWidget {
  const NotificationSettings({Key? key}) : super(key: key);

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
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF990000),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: true,
            onChanged: (val) {},
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Email Alerts'),
            value: true,
            onChanged: (val) {},
            secondary: const Icon(Icons.email),
          ),
          SwitchListTile(
            title: const Text('WhatsApp Updates'),
            value: false,
            onChanged: (val) {},
            secondary: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }
}
