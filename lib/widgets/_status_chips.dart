import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/utils/utils.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';
import '../shared/_themes.dart';

class StatusChips extends StatelessWidget {
  const StatusChips({super.key});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NoteController>();

    return Obx(() {
      return SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('All'),
                selected: noteController.selectedStatus == null,
                onSelected: (_) => noteController.filterByStatus(null),
                backgroundColor: Colors.grey.shade200,
                selectedColor: primaryColor.withValues(alpha: 0.2),
                checkmarkColor: primaryColor,
                labelStyle: TextStyle(
                  color: noteController.selectedStatus == null
                      ? primaryColor
                      : textSecondary,
                  fontWeight: noteController.selectedStatus == null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),

            ...NoteStatus.values.map((status) {
              final isSelected = noteController.selectedStatus == status;
              final count = noteController.notes
                  .where((note) => note.status == status)
                  .length;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(status.emoji),
                      const SizedBox(width: 4),
                      Text('${status.label} ($count)'),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => noteController.filterByStatus(status),
                  backgroundColor: getStatusColor(
                    status,
                  ).withValues(alpha: 0.1),
                  selectedColor: getStatusColor(status).withValues(alpha: 0.3),
                  checkmarkColor: getStatusColor(status),
                  labelStyle: TextStyle(
                    color: isSelected ? getStatusColor(status) : textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
