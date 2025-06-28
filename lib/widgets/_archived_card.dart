import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_book/controllers/note_controller.dart';
import 'package:note_book/models/note.dart';
import 'package:note_book/pages/add_note/add_note_page.dart';
import 'package:note_book/pages/note_details/note_details_page.dart';
import 'package:note_book/shared/_themes.dart';

class ArchivedNoteCard extends StatelessWidget {
  final Note note;

  const ArchivedNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();

    return GestureDetector(
      onTap: () => Get.to(() => NoteDetailsPage(note: note)),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(note.color), width: 1),
          borderRadius: BorderRadius.circular(12),
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
                      border: Border.all(width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.archive, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Archived',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Archived ${DateFormat('MMM d, y').format(note.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenuAction(value, noteController),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'unarchive',
                        child: Row(
                          children: [
                            Icon(Icons.unarchive),
                            SizedBox(width: 8),
                            Text('Unarchive'),
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
                            Icon(Icons.delete_forever, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Delete Permanently',
                              style: TextStyle(color: Colors.red),
                            ),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              if (note.content.isNotEmpty) ...[
                Text(
                  note.content,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: textSecondary),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
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
                        color: textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        note.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (note.tags.isNotEmpty) ...[
                    Icon(Icons.tag, size: 12, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${note.tags.length} tags',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: textSecondary),
                    ),
                  ],
                  const Spacer(),
                  Icon(Icons.archive_outlined, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action, NoteController noteController) {
    switch (action) {
      case 'unarchive':
        noteController.updateNoteStatus(note.id, NoteStatus.pending);
        Get.snackbar(
          'Success',
          'Note unarchived successfully',
          backgroundColor: success.withValues(alpha: 0.1),
          colorText: success,
        );
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
            title: const Text('Delete Note Permanently'),
            content: const Text(
              'Are you sure you want to permanently delete this note? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  noteController.deleteNote(note.id);
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Note deleted permanently',
                    backgroundColor: error.withValues(alpha: 0.1),
                    colorText: error,
                  );
                },
                style: TextButton.styleFrom(foregroundColor: error),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        break;
    }
  }
}
