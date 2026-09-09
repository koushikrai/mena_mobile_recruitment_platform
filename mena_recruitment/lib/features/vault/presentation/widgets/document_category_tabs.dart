import 'package:flutter/material.dart';

class DocumentCategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const DocumentCategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => onSelected(cat),
              selectedColor: const Color(0xFF990000),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF990000),
              ),
              backgroundColor: const Color(0xFFF8F9FF),
            ),
          );
        }).toList(),
      ),
    );
  }
}
