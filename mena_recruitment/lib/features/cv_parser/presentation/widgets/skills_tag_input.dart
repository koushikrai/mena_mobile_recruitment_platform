import 'package:flutter/material.dart';

class SkillsTagInput extends StatelessWidget {
  final List<String> skills;
  final Function(String) onRemove;

  const SkillsTagInput({
    Key? key,
    required this.skills,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...skills.map((skill) => Chip(
          label: Text(skill),
          onDeleted: () => onRemove(skill),
          backgroundColor: const Color(0xFFF8F9FF),
          deleteIconColor: const Color(0xFF990000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
        )),
        ActionChip(
          label: const Text('Add Skill'),
          avatar: const Icon(Icons.add, size: 16),
          onPressed: () {},
        ),
      ],
    );
  }
}
