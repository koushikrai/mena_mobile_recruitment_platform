import 'package:flutter/material.dart';

class ExperienceFormCard extends StatelessWidget {
  final String title;
  final String company;
  final String duration;
  final VoidCallback onDelete;

  const ExperienceFormCard({
    super.key,
    required this.title,
    required this.company,
    required this.duration,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(company, style: const TextStyle(color: Colors.grey)),
                      Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
