import 'package:flutter/material.dart';

class AIFeaturesCard extends StatelessWidget {
  const AIFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Extraction Features',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF990000),
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF059669)),
              title: Text('Extracts personal info and contact details'),
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF059669)),
              title: Text('Calculates GCC quota eligibility'),
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF059669)),
              title: Text('Parses skills and experience'),
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
