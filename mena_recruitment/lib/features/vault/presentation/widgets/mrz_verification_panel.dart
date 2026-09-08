import 'package:flutter/material.dart';
import 'package:mena_recruitment/features/vault/domain/passport_mrz_entity.dart';

class MrzVerificationPanel extends StatelessWidget {
  final PassportMRZ? mrzData;

  const MrzVerificationPanel({Key? key, this.mrzData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mrzData == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0F1E36).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Extracted Data',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F1E36),
            ),
          ),
          const SizedBox(height: 12),
          _buildRow('Passport No', mrzData!.passportNumber),
          _buildRow('Surname', mrzData!.surname),
          _buildRow('Given Names', mrzData!.givenNames),
          _buildRow('Nationality', mrzData!.nationality),
          _buildRow('Expiry', mrzData!.expiryDate.toString().split(' ')[0]),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F1E36),
            ),
          ),
        ],
      ),
    );
  }
}
