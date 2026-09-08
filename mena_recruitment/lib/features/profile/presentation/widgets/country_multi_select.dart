import 'package:flutter/material.dart';

class CountryMultiSelect extends StatelessWidget {
  final List<String> selectedCountries;
  final List<String> allCountries = const [
    'Saudi Arabia', 'UAE', 'Qatar', 'Oman', 'Kuwait', 'Bahrain'
  ];

  const CountryMultiSelect({Key? key, required this.selectedCountries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allCountries.map((country) {
        final isSelected = selectedCountries.contains(country);
        return FilterChip(
          label: Text(country),
          selected: isSelected,
          onSelected: (val) {},
          selectedColor: const Color(0xFF0F1E36),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0F1E36),
          ),
          backgroundColor: Colors.white,
        );
      }).toList(),
    );
  }
}
