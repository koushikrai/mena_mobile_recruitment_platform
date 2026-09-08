import 'package:flutter/material.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/presentation/widgets/country_multi_select.dart';

class RelocationPrefsCard extends StatelessWidget {
  final CandidateProfile profile;

  const RelocationPrefsCard({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: const Color(0xFFF8F9FF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Relocation Preferences',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF990000),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Preferred Countries', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            CountryMultiSelect(selectedCountries: profile.preferredCountries),
            const SizedBox(height: 16),
            const Text('Expected Salary', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: profile.expectedCurrency,
                    items: const [
                      DropdownMenuItem(value: 'SAR', child: Text('SAR')),
                      DropdownMenuItem(value: 'AED', child: Text('AED')),
                      DropdownMenuItem(value: 'QAR', child: Text('QAR')),
                    ],
                    onChanged: (val) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    initialValue: profile.expectedSalary.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Notice Period', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: profile.noticePeriod,
              items: const [
                DropdownMenuItem(value: 'Immediate', child: Text('Immediate')),
                DropdownMenuItem(value: '15 Days', child: Text('15 Days')),
                DropdownMenuItem(value: '30 Days', child: Text('30 Days')),
                DropdownMenuItem(value: '60 Days', child: Text('60 Days')),
              ],
              onChanged: (val) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Family Status', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: 'Single',
              items: const [
                DropdownMenuItem(value: 'Single', child: Text('Single')),
                DropdownMenuItem(value: 'Married (Family Relocation)', child: Text('Married (Family Relocation)')),
              ],
              onChanged: (val) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
