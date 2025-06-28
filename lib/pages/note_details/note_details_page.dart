import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/note_controller.dart';
import '../../models/note.dart';
import '../../shared/_themes.dart';
import '../add_note/add_note_page.dart';

class NoteDetailsPage extends StatelessWidget {
  final Note note;

  const NoteDetailsPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _shareNote(),
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () => noteController.togglePin(note.id),
            icon: Obx(() {
              final currentNote = noteController.notes.firstWhere(
                (n) => n.id == note.id,
                orElse: () => note,
              );
              return Icon(
                currentNote.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: currentNote.isPinned ? primaryColor : null,
              );
            }),
          ),
          PopupMenuButton<String>(
            onSelected: (value) =>
                _handleMenuAction(value, noteController, context),
            itemBuilder: (context) => [
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
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Copy to Clipboard'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: error),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              note.title,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Metadata Row
            Row(
              children: [
                if (note.category != 'General') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      note.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(note.updatedAt),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: textSecondary),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Content
            if (note.content.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(note.content),
              ),
              const SizedBox(height: 24),
            ],

            // Tags
            if (note.tags.isNotEmpty) ...[
              Text(
                'Tags',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: note.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Note Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note Information',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      'Created',
                      DateFormat('MMM d, yyyy • h:mm a').format(note.createdAt),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      'Last Modified',
                      DateFormat('MMM d, yyyy • h:mm a').format(note.updatedAt),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      'Character Count',
                      '${note.content.length} characters',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      'Word Count',
                      '${note.content.split(' ').where((word) => word.isNotEmpty).length} words',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNotePage(note: note)),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  void _handleMenuAction(
    String action,
    NoteController noteController,
    BuildContext context,
  ) {
    switch (action) {
      case 'edit':
        Get.to(() => AddNotePage(note: note));
        break;
      case 'copy':
        Clipboard.setData(
          ClipboardData(text: '${note.title}\n\n${note.content}'),
        );
        Get.snackbar(
          'Copied',
          'Note content copied to clipboard',
          backgroundColor: success.withValues(alpha: 0.1),
          colorText: success,
        );
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
                  Get.back(); // Close dialog
                  Get.back(); // Close details page
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

  void _shareNote() {
    final shareText = '${note.title}\n\n${note.content}';

    // For now, just copy to clipboard since share functionality requires additional setup
    Clipboard.setData(ClipboardData(text: shareText));
    Get.snackbar(
      'Copied to Clipboard',
      'Note content is ready to share',
      backgroundColor: primaryColor.withValues(alpha: 0.1),
      colorText: primaryColor,
    );
  }
}
