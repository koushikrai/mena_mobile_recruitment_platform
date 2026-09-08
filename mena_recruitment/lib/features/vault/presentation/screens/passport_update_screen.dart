import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/expiry_reminder_config.dart';

class PassportUpdateScreen extends ConsumerWidget {
  const PassportUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Passport Details'),
        backgroundColor: const Color(0xFF0F1E36),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Active Passport Card Placeholder
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: const Color(0xFFF8F9FF),
              child: const ListTile(
                leading: Icon(Icons.flag, size: 40),
                title: Text('Passport: *******4567'),
                subtitle: Text('Expires in 14 months'),
                trailing: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              color: Color(0xFFE0F2FE),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('GCC 6-Month Rule: Your passport must have at least 6 months validity for most GCC work visas.'),
              ),
            ),
            const SizedBox(height: 24),
            const ExpiryReminderConfig(),
            const SizedBox(height: 24),
            _buildTextField('Passport Number'),
            const SizedBox(height: 12),
            _buildTextField('Issuing Country'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('Issue Date')),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Expiry Date')),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F1E36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text('Update Passport Details', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
