import 'package:flutter/material.dart';

class CountryExplorerGrid extends StatelessWidget {
  const CountryExplorerGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countries = [
      {'name': 'Saudi Arabia', 'flag': '🇸🇦'},
      {'name': 'UAE', 'flag': '🇦🇪'},
      {'name': 'Qatar', 'flag': '🇶🇦'},
      {'name': 'Oman', 'flag': '🇴🇲'},
      {'name': 'Kuwait', 'flag': '🇰🇼'},
      {'name': 'Bahrain', 'flag': '🇧🇭'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: const Color(0xFFF8F9FF),
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(country['flag']!, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                country['name']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1E36),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
