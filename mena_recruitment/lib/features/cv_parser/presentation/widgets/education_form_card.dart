import 'package:flutter/material.dart';
import 'attestation_status_dropdown.dart';

class EducationFormCard extends StatelessWidget {
  final String degree;
  final String institution;
  final String year;
  final String status;

  const EducationFormCard({
    Key? key,
    required this.degree,
    required this.institution,
    required this.year,
    required this.status,
  }) : super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(degree, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('$institution • $year', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            AttestationStatusDropdown(value: status, onChanged: (v) {}),
          ],
        ),
      ),
    );
  }
}
