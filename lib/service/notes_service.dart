import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:note_book/models/note.dart';

class DataService {
  static Future<List<Note>> loadInitialNotes() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/notes.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((json) => Note.fromMap(json)).toList();
    } catch (e) {
      log('Error loading initial notes: $e');
      // log(js);
      // Return some default notes if JSON fails to load
      return _getDefaultNotes();
    }
  }

  static List<Note> _getDefaultNotes() {
    final now = DateTime.now();
    return [
      Note(
        id: '1',
        title: 'Welcome to Note Book!',
        content:
            'This is your first note. You can edit, delete, pin, and organize your notes by categories and tags. The app supports different status states to help you track your progress!',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        category: 'General',
        tags: ['welcome', 'introduction'],
        isPinned: true,
        color: 0xFF81C784, // Light green
        status: NoteStatus.completed,
      ),
      Note(
        id: '2',
        title: 'Getting Started',
        content:
            'Here are some tips to get you started:\n\n• Tap the + button to create a new note\n• Use the search bar to find notes quickly\n• Filter by categories and status\n• Pin important notes to keep them at the top',
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
        category: 'Tutorial',
        tags: ['tips', 'tutorial'],
        isPinned: false,
        color: 0xFF64B5F6, // Light blue
        status: NoteStatus.pending,
      ),
    ];
  }
}
