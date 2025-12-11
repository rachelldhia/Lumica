import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/utils/loading_util.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
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

  // Loading state - used for skeleton UI while LoadingUtil shows dialog
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    isLoading.value = true;

    // Defer showing dialog until after current frame to avoid build context errors
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isLoading.value) {
        LoadingUtil.show(message: 'Loading notes...');
      }
    });

    try {
      final result = await _noteRepository.getNotes();

      result.fold(
        (failure) {
          AppSnackbar.error(failure.message, title: 'Error');
        },
        (data) {
          notes.assignAll(data);
        },
      );
    } catch (e) {
      AppSnackbar.error('Failed to load notes', title: 'Error');
    } finally {
      isLoading.value = false;
      LoadingUtil.hide();
    }
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
  Future<bool> createNote(Note note, {bool showSnackbar = true}) async {
    LoadingUtil.show(message: 'Creating note...');
    try {
      final result = await _noteRepository.createNote(note);
      return result.fold(
        (failure) {
          AppSnackbar.error(failure.message, title: 'Error');
          return false;
        },
        (newNote) {
          notes.add(newNote);
          if (showSnackbar) {
            AppSnackbar.success('Note created successfully');
          }
          return true;
        },
      );
    } catch (e) {
      AppSnackbar.error('Failed to create note', title: 'Error');
      return false;
    } finally {
      LoadingUtil.hide();
    }
  }

  // Update an existing note
  Future<bool> updateNote(Note updatedNote, {bool showSnackbar = true}) async {
    LoadingUtil.show(message: 'Updating note...');
    try {
      final result = await _noteRepository.updateNote(updatedNote);
      return result.fold(
        (failure) {
          AppSnackbar.error(failure.message, title: 'Error');
          return false;
        },
        (note) {
          final index = notes.indexWhere((n) => n.id == note.id);
          if (index != -1) {
            notes[index] = note;
          }
          if (showSnackbar) {
            AppSnackbar.success('Note updated successfully');
          }
          return true;
        },
      );
    } catch (e) {
      AppSnackbar.error('Failed to update note', title: 'Error');
      return false;
    } finally {
      LoadingUtil.hide();
    }
  }

  /// Prompt delete confirmation and handle flow
  Future<void> promptDeleteNote(
    String noteId, {
    String? noteTitle,
    bool closePage = false,
  }) async {
    // 1. Show Confirmation Dialog
    // We expect the dialog to return TRUE if confirmed, FALSE/NULL otherwise.
    final bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Note?',
          style: AppTextTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${noteTitle ?? 'this note'}"? This action cannot be undone.',
          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.darkBrown.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Delete',
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    // 2. Guard: If not confirmed, stopping here.
    if (confirm != true) return;

    // 3. Proceed to Delete
    LoadingUtil.show(message: 'Deleting note...');

    try {
      final result = await _noteRepository.deleteNote(noteId);

      await result.fold(
        (failure) async {
          LoadingUtil.hide();
          AppSnackbar.error(failure.message, title: 'Error');
        },
        (_) async {
          // Success!
          // Remove from local list if exists
          notes.removeWhere((note) => note.id == noteId);

          LoadingUtil.hide(); // Hide loading BEFORE navigation

          if (closePage) {
            // Safety delay just to ensure Dialog is 100% gone physically
            await Future.delayed(const Duration(milliseconds: 100));
            Get.back(); // Close Notice Editor
            AppSnackbar.success('Note deleted successfully');
          } else {
            AppSnackbar.success('Note deleted successfully');
          }
        },
      );
    } catch (e) {
      LoadingUtil.hide();
      AppSnackbar.error('Failed to delete note: $e', title: 'Error');
    }
  }

  // Save note (Create or Update based on ID)
  // This handles the business logic of constructing the Note object
  Future<bool> saveNote({
    String? id,
    required String title,
    required String contentJson, // Expecting JSON string from Quill
    required NoteCategory category,
    Note? existingNote, // Optional: if we have the original note object
    bool showSnackbar = true,
  }) async {
    // Basic validation
    if (title.isEmpty &&
        (contentJson.isEmpty || contentJson == '[{"insert":"\\n"}]')) {
      // Maybe allow empty notes? Or return false?
      // For now let's proceed but maybe defaulting title is enough
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
      return await updateNote(updatedNote, showSnackbar: showSnackbar);
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
      return await createNote(newNote, showSnackbar: showSnackbar);
    }
  }

  // Save and navigate back
  Future<void> saveAndClose({
    String? id,
    required String title,
    required String contentJson,
    required NoteCategory category,
    Note? existingNote,
  }) async {
    // Check if completely empty -> Just close without saving
    // Simple check: title empty AND content is just newline or empty
    final isContentEmpty =
        contentJson.isEmpty || contentJson == '[{"insert":"\\n"}]';
    if (title.isEmpty && isContentEmpty) {
      Get.back();
      return;
    }

    final success = await saveNote(
      id: id,
      title: title,
      contentJson: contentJson,
      category: category,
      existingNote: existingNote,
      showSnackbar: false, // Don't show snackbar while on this page
    );

    if (success) {
      // Wait for any existing overlay/loading to settle
      LoadingUtil.hide(); // Ensure loading is definitely gone

      Get.back(); // Pop the page

      // Show snackbar AFTER navigation to avoid overlay conflict
      // Short delay to let the route transition happen
      Future.delayed(const Duration(milliseconds: 350), () {
        AppSnackbar.success('Note saved successfully');
      });
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
