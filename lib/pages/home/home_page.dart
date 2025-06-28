import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controllers/note_controller.dart';
import 'package:note_book/widgets/_note_card.dart';
import 'package:note_book/widgets/_notes_empty_state.dart';
import 'package:note_book/widgets/_search_bar.dart';
import 'package:note_book/widgets/_status_chips.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: CustomSearchBar(),
            ),

            // Status Chips
            const StatusChips(),

            const SizedBox(height: 16),

            // Notes List
            Expanded(
              child: Obx(() {
                if (noteController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (noteController.filteredNotes.isEmpty) {
                  return buildEmptyState(context);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: noteController.filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = noteController.filteredNotes[index];
                      return NoteCard(note: note);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
