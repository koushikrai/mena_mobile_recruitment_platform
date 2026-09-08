import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentCategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const DocumentCategoryTabs({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  }) : super(key: key);

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
              selectedColor: const Color(0xFF0F1E36),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF0F1E36),
              ),
              backgroundColor: const Color(0xFFF8F9FF),
            ),
          );
        }).toList(),
      ),
    );
  }
}
