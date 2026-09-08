import 'package:flutter/material.dart';

class AttestationStatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const AttestationStatusDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: const [
        DropdownMenuItem(value: 'Attested by MOFA', child: Text('Attested by MOFA')),
        DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
        DropdownMenuItem(value: 'Not Started', child: Text('Not Started')),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Attestation Status',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
