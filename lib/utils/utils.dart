import 'package:flutter/material.dart';
import 'package:note_book/models/note.dart';

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Morning';
  if (hour < 17) return 'Afternoon';
  return 'Evening';
}

Color getStatusColor(NoteStatus status) {
  switch (status) {
    case NoteStatus.pending:
      return Colors.orange;
    case NoteStatus.inProgress:
      return Colors.blue;
    case NoteStatus.completed:
      return Colors.green;
    case NoteStatus.archived:
      return Colors.grey;
    case NoteStatus.cancelled:
      return Colors.red;
  }
}
