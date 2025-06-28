import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controllers/note_controller.dart';
import 'package:note_book/shared/_themes.dart';
import 'package:note_book/widgets/_archived_card.dart';

class ArchivedNotesPage extends StatelessWidget {
  const ArchivedNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final archivedNotes = noteController.archivedNotes;

          if (archivedNotes.isEmpty) {
            // Show only centered header when no archived notes
            return Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      archivedColor.withValues(alpha: 0.2),
                      primaryColor.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: archivedColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 80,
                      color: archivedColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Archived Notes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: archivedColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notes you archive will appear here',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Show header and list when there are archived notes
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      archivedColor.withValues(alpha: 0.2),
                      primaryColor.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: archivedColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 48,
                      color: archivedColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${archivedNotes.length} Archived Notes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: archivedColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Notes you\'ve archived are stored here',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Archived Notes List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: archivedNotes.length,
                    itemBuilder: (context, index) {
                      final note = archivedNotes[index];
                      return ArchivedNoteCard(note: note);
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
