import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';
import '../pages/add_note/add_note_page.dart';
import '../pages/note_details/note_details_page.dart';
import '../shared/_themes.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();

    return GestureDetector(
      onTap: () => Get.to(() => NoteDetailsPage(note: note)),
      child: Card(
        elevation: .1,
        margin: const EdgeInsets.only(bottom: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Color(note.color), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: getStatusColor(note.status),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          note.status.emoji,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          note.status.label,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: getStatusColor(note.status),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (note.isPinned)
                    const Icon(Icons.push_pin, size: 16, color: accentColor),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenuAction(value, noteController),
                    itemBuilder: (context) => [
                      // Status submenu
                      PopupMenuItem(
                        value: 'status',
                        child: Row(
                          children: [
                            Icon(Icons.flag),
                            SizedBox(width: 8),
                            Text('Change Status'),
                            Spacer(),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'pin',
                        child: Row(
                          children: [
                            Icon(
                              note.isPinned
                                  ? Icons.push_pin_outlined
                                  : Icons.push_pin,
                            ),
                            const SizedBox(width: 8),
                            Text(note.isPinned ? 'Unpin' : 'Pin'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility),
                            SizedBox(width: 8),
                            Text('View Details'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              if (note.content.isNotEmpty) ...[
                Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Tags
              if (note.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: note.tags
                      .take(3)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
              ],

              Row(
                children: [
                  if (note.category != 'General') ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: secondaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        note.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ] else
                    const Spacer(),
                  Text(
                    DateFormat('MMM d').format(note.updatedAt),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  void _handleMenuAction(String action, NoteController noteController) {
    switch (action) {
      case 'status':
        _showStatusDialog(noteController);
        break;
      case 'pin':
        noteController.togglePin(note.id);
        break;
      case 'view':
        Get.to(() => NoteDetailsPage(note: note));
        break;
      case 'edit':
        Get.to(() => AddNotePage(note: note));
        break;
      case 'delete':
        Get.dialog(
          AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  noteController.deleteNote(note.id);
                  Get.back();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        break;
    }
  }

  void _showStatusDialog(NoteController noteController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: NoteStatus.values.map((status) {
            return ListTile(
              leading: Text(status.emoji),
              title: Text(status.label),
              trailing: note.status == status ? const Icon(Icons.check) : null,
              onTap: () {
                noteController.updateNoteStatus(note.id, status);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
