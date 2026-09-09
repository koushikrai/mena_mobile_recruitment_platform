import 'package:flutter/material.dart';
import '../../domain/application_entity.dart';
import 'missing_document_alert.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplication application;

  const ApplicationCard({super.key, required this.application});

  Color _getSeverityColor(StatusSeverity severity) {
    switch (severity) {
      case StatusSeverity.verified: return const Color(0xFF059669);
      case StatusSeverity.review: return const Color(0xFF6E0000);
      case StatusSeverity.critical: return Colors.red;
      case StatusSeverity.info: return const Color(0xFF990000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFF8F9FF),
                  child: Icon(Icons.business, color: Color(0xFF990000)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF990000),
                        ),
                      ),
                      Text(
                        '${application.companyName} • ${application.city}, ${application.countryCode}',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getSeverityColor(application.severity).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                application.statusLabel,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  color: _getSeverityColor(application.severity),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            if (application.missingDocuments.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...application.missingDocuments.map((doc) => MissingDocumentAlert(
                documentName: doc,
                deadline: application.nextDeadline,
              )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF990000),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Upload Missing Document', style: TextStyle(color: Colors.white)),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (application.currentStage == RelocationStage.offerIssued)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('View Offer Letter'),
                    ),
                  ),
                if (application.currentStage == RelocationStage.offerIssued)
                  const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Chat with Recruiter'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
