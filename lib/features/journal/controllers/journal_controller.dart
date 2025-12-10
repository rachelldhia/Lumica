import 'package:get/get.dart';
import 'package:lumica_app/domain/entities/note.dart';
import 'package:lumica_app/domain/entities/note_category.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';

class JournalController extends GetxController {
  final NoteRepository _noteRepository;

  JournalController({NoteRepository? noteRepository})
    : _noteRepository = noteRepository ?? Get.find<NoteRepository>();

  // Observable list of all notes
  final RxList<Note> notes = <Note>[].obs;

  // Selected date for filtering
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    isLoading.value = true;
    final result = await _noteRepository.getNotes();

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar('Error', failure.message);
      },
      (data) {
        notes.assignAll(data);
        isLoading.value = false;
      },
    );
  }

  // Get filtered notes based on selected date and search
  List<Note> get filteredNotes {
    var result = notes.where((note) {
      // Filter by selected date (check if note was created on selected date)
      final noteDate = note.createdAt;
      final selected = selectedDate.value;

      final isSameDate =
          noteDate.year == selected.year &&
          noteDate.month == selected.month &&
          noteDate.day == selected.day;

      if (!isSameDate) {
        return false;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }

      return true;
    }).toList();

    // Sort by updated date (newest first)
    result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return result;
  }

  // Get list of dates that have notes
  List<DateTime> get getDatesWithNotes {
    final datesSet = <String>{}; // Use set to avoid duplicates
    final datesList = <DateTime>[];

    for (var note in notes) {
      final date = note.createdAt;
      final dateKey = '${date.year}-${date.month}-${date.day}';

      if (!datesSet.contains(dateKey)) {
        datesSet.add(dateKey);
        datesList.add(DateTime(date.year, date.month, date.day));
      }
    }

    // Sort dates (newest first)
    datesList.sort((a, b) => b.compareTo(a));
    return datesList;
  }

  // Create a new note
  Future<void> createNote(Note note) async {
    final result = await _noteRepository.createNote(note);
    result.fold((failure) => Get.snackbar('Error', failure.message), (newNote) {
      notes.add(newNote);
      Get.back(); // Navigate back after success
    });
  }

  // Update an existing note
  Future<void> updateNote(Note updatedNote) async {
    final result = await _noteRepository.updateNote(updatedNote);
    result.fold((failure) => Get.snackbar('Error', failure.message), (note) {
      final index = notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        notes[index] = note;
      }
      Get.back(); // Navigate back after success
    });
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    final result = await _noteRepository.deleteNote(noteId);
    result.fold((failure) => Get.snackbar('Error', failure.message), (_) {
      notes.removeWhere((note) => note.id == noteId);
    });
  }

  // Save note (Create or Update based on ID)
  // This handles the business logic of constructing the Note object
  void saveNote({
    String? id,
    required String title,
    required String contentJson, // Expecting JSON string from Quill
    required NoteCategory category,
    Note? existingNote, // Optional: if we have the original note object
  }) {
    if (title.isEmpty) {
      // Logic to check empty content could be here, but usually passed in
      // For now assuming validation happens before or we construct with defaults
    }

    final now = DateTime.now();

    if (id != null && existingNote != null) {
      // Update
      final updatedNote = existingNote.copyWith(
        title: title.isEmpty ? 'Untitled' : title,
        content: contentJson,
        category: category,
        updatedAt: now,
      );
      updateNote(updatedNote);
    } else {
      // Create
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '00000000-0000-0000-0000-000000000000', // Get from Auth Service
        title: title.isEmpty ? 'Untitled' : title,
        content: contentJson,
        category: category,
        createdAt: now,
        updatedAt: now,
      );
      createNote(newNote);
    }
  }

  // Get a note by ID
  Note? getNoteById(String id) {
    // Since we load all notes on init, we can just find it in the list
    // This assumes we have a complete list. If implementing pagination, we might need to fetch from repo.
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
}
