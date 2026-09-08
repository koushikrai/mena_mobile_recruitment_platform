import 'package:flutter/material.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';

class VaultDocumentTile extends StatelessWidget {
  final VaultDocument document;
  final VoidCallback onTap;

  const VaultDocumentTile({
    Key? key,
    required this.document,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: const Color(0xFFF8F9FF),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1E36).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconForCategory(document.category),
            color: const Color(0xFF0F1E36),
          ),
        ),
        title: Text(
          document.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F1E36),
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              document.documentNumber,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (document.isVerified)
                  _buildBadge('Verified', const Color(0xFF059669))
                else
                  _buildBadge('Pending', const Color(0xFFD97706)),
                if (document.expiryDate != null) ...[
                  const SizedBox(width: 8),
                  _buildExpiryCountdown(document.expiryDate!),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconForCategory(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.passport: return Icons.book;
      case DocumentCategory.visa: return Icons.airplane_ticket;
      case DocumentCategory.educationAttestation: return Icons.school;
      case DocumentCategory.medicalGamca: return Icons.local_hospital;
      case DocumentCategory.policeClearance: return Icons.local_police;
      case DocumentCategory.tradeLicense: return Icons.work;
    }
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExpiryCountdown(DateTime expiry) {
    final days = expiry.difference(DateTime.now()).inDays;
    final color = days < 30 ? Colors.red : (days < 90 ? const Color(0xFFD97706) : Colors.grey);
    return Text(
      days > 0 ? '$days days left' : 'Expired',
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
