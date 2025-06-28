import 'dart:developer';

import 'package:get/get.dart';
import 'package:note_book/models/note.dart';
import 'package:note_book/service/notes_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteController extends GetxController {
  final RxList<Note> _notes = <Note>[].obs;
  final RxList<Note> _filteredNotes = <Note>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = 'All'.obs;
  final Rx<NoteStatus?> _selectedStatus = Rx<NoteStatus?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isFirstTime = true.obs;

  List<Note> get notes => _notes;
  List<Note> get filteredNotes => _filteredNotes;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  NoteStatus? get selectedStatus => _selectedStatus.value;
  bool get isLoading => _isLoading.value;
  bool get isFirstTime => _isFirstTime.value;

  List<String> get categories {
    final cats = _notes.map((note) => note.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  List<Note> get pinnedNotes => _notes.where((note) => note.isPinned).toList();
  List<Note> get unpinnedNotes =>
      _notes.where((note) => !note.isPinned).toList();

  // Status-based getters
  List<Note> get pendingNotes =>
      _notes.where((note) => note.status == NoteStatus.pending).toList();
  List<Note> get inProgressNotes =>
      _notes.where((note) => note.status == NoteStatus.inProgress).toList();
  List<Note> get completedNotes =>
      _notes.where((note) => note.status == NoteStatus.completed).toList();
  List<Note> get archivedNotes =>
      _notes.where((note) => note.status == NoteStatus.archived).toList();
  List<Note> get cancelledNotes =>
      _notes.where((note) => note.status == NoteStatus.cancelled).toList();

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getStringList('notes');
      final hasLoadedBefore = prefs.getBool('has_loaded_initial_data') ?? false;

      if (!hasLoadedBefore || notesJson == null || notesJson.isEmpty) {
        // First time loading or no saved notes - load from JSON

        await _loadInitialNotes(prefs);
        _isFirstTime.value = !hasLoadedBefore;
      } else {
        // Load from SharedPreferences

        _notes.value = notesJson
            .map((noteJson) => Note.fromJson(noteJson))
            .toList();
        _isFirstTime.value = false;
      }

      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _filterNotes();

      if (_isFirstTime.value) {
        Get.snackbar(
          'Welcome!',
          '${_notes.length} sample notes have been loaded to get you started',
          duration: const Duration(seconds: 3),
          backgroundColor: Get.theme.primaryColor.withValues(alpha: 0.1),
          colorText: Get.theme.primaryColor,
        );
      }
    } catch (e) {
      log('Error loading notes: $e');
      Get.snackbar('Error', 'Failed to load notes: $e');
      // Load default notes as fallback
      await _loadDefaultNotes();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadInitialNotes(SharedPreferences prefs) async {
    try {
      log('Attempting to load notes from DataService...');
      final initialNotes = await DataService.loadInitialNotes();
      log('DataService returned ${initialNotes.length} notes');

      _notes.value = initialNotes;

      // Save to SharedPreferences and mark as loaded
      if (initialNotes.isNotEmpty) {
        await _saveNotesToPrefs();
        await prefs.setBool('has_loaded_initial_data', true);
        log('Initial notes saved to SharedPreferences');
      }
    } catch (e) {
      log('Error loading initial notes: $e');
      await _loadDefaultNotes();
    }
  }

  Future<void> _loadDefaultNotes() async {
    try {
      log('Loading default notes as fallback...');
      final defaultNotes = await DataService.loadInitialNotes();
      _notes.value = defaultNotes;
      await saveNotes();
      log('Default notes loaded: ${defaultNotes.length}');
    } catch (e) {
      log('Error loading default notes: $e');
      _notes.value = [];
    }
  }

  Future<void> _saveNotesToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = _notes.map((note) => note.toJson()).toList();
      await prefs.setStringList('notes', notesJson);
      log('Saved ${notesJson.length} notes to SharedPreferences');
    } catch (e) {
      log('Error saving notes to SharedPreferences: $e');
      rethrow;
    }
  }

  Future<void> saveNotes() async {
    try {
      await _saveNotesToPrefs();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save notes: $e');
    }
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await saveNotes();
    _filterNotes();
    Get.snackbar('Success', 'Note added successfully');
  }

  Future<void> updateNote(Note updatedNote) async {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      await saveNotes();
      _filterNotes();
      Get.snackbar('Success', 'Note updated successfully');
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await saveNotes();
    _filterNotes();
    Get.snackbar('Success', 'Note deleted successfully');
  }

  Future<void> togglePin(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(isPinned: !_notes[index].isPinned);
      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      await saveNotes();
      _filterNotes();
    }
  }

  Future<void> updateNoteStatus(String id, NoteStatus status) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      await saveNotes();
      _filterNotes();
      Get.snackbar('Success', 'Note status updated to ${status.label}');
    }
  }

  void searchNotes(String query) {
    _searchQuery.value = query;
    _filterNotes();
  }

  void filterByCategory(String category) {
    _selectedCategory.value = category;
    _filterNotes();
  }

  void filterByStatus(NoteStatus? status) {
    _selectedStatus.value = status;
    _filterNotes();
  }

  void _filterNotes() {
    List<Note> filtered = List.from(_notes);

    // Filter by category
    if (_selectedCategory.value != 'All') {
      filtered = filtered
          .where((note) => note.category == _selectedCategory.value)
          .toList();
    }

    // Filter by status
    if (_selectedStatus.value != null) {
      filtered = filtered
          .where((note) => note.status == _selectedStatus.value)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (note) =>
                note.title.toLowerCase().contains(
                  _searchQuery.value.toLowerCase(),
                ) ||
                note.content.toLowerCase().contains(
                  _searchQuery.value.toLowerCase(),
                ) ||
                note.tags.any(
                  (tag) => tag.toLowerCase().contains(
                    _searchQuery.value.toLowerCase(),
                  ),
                ),
          )
          .toList();
    }

    _filteredNotes.value = filtered;
  }

  void clearSearch() {
    _searchQuery.value = '';
    _filterNotes();
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedCategory.value = 'All';
    _selectedStatus.value = null;
    _filterNotes();
  }

  // Method to reset and reload initial data (useful for testing or settings)
  Future<void> resetToInitialData() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notes');
      await prefs.remove('has_loaded_initial_data');
      await loadNotes();
      Get.snackbar('Success', 'App data has been reset to initial state');
    } catch (e) {
      Get.snackbar('Error', 'Failed to reset data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Force load from JSON (for testing)
  Future<void> forceLoadFromJson() async {
    _isLoading.value = true;
    try {
      log('Force loading from JSON...');
      final initialNotes = await DataService.loadInitialNotes();
      _notes.value = initialNotes;
      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      await saveNotes();
      _filterNotes();
      log('Force loaded ${initialNotes.length} notes from JSON');
      Get.snackbar('Success', '${initialNotes.length} notes loaded from JSON');
    } catch (e) {
      log('Error force loading from JSON: $e');
      Get.snackbar('Error', 'Failed to load from JSON: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteMultipleNotes(List<String> ids) async {
    _notes.removeWhere((note) => ids.contains(note.id));
    await saveNotes();
    _filterNotes();
    Get.snackbar('Success', '${ids.length} notes deleted successfully');
  }

  Future<void> updateMultipleNotesStatus(
    List<String> ids,
    NoteStatus status,
  ) async {
    for (final id in ids) {
      final index = _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
      }
    }
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await saveNotes();
    _filterNotes();
    Get.snackbar('Success', '${ids.length} notes updated to ${status.label}');
  }

  // Get notes by category
  List<Note> getNotesByCategory(String category) {
    if (category == 'All') return _notes;
    return _notes.where((note) => note.category == category).toList();
  }

  // Get notes by status
  List<Note> getNotesByStatus(NoteStatus status) {
    return _notes.where((note) => note.status == status).toList();
  }
}
