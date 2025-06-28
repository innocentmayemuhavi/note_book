import 'package:flutter/material.dart';

Widget buildEmptyState(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'No notes yet',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the + button to create your first note',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
        ),
      ],
    ),
  );
}
