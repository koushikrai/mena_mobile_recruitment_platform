import 'package:flutter/material.dart';

class ApplicationFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ApplicationFilterTabs({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Under Review', 'Interviewing', 'Offer & Visa', 'Archived'];
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onFilterChanged(filter);
              },
              selectedColor: const Color(0xFF0F1E36),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF0F1E36),
                fontFamily: 'Plus Jakarta Sans',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          );
        },
      ),
    );
  }
}
