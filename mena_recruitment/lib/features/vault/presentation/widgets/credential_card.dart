import 'package:flutter/material.dart';
import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';

class CredentialCard extends StatelessWidget {
  final Certification certification;

  const CredentialCard({Key? key, required this.certification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: const Color(0xFFF8F9FF),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    certification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF0F1E36),
                    ),
                  ),
                ),
                if (certification.isVerified)
                  const Icon(Icons.verified, color: Color(0xFF059669), size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              certification.issuingAuthority,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              certification.credentialId,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Valid From: ${certification.validFrom.toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (certification.validUntil != null)
                  Text(
                    'Until: ${certification.validUntil.toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
