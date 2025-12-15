import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/utils/debounce_util.dart';
import 'package:lumica_app/core/utils/loading_util.dart';
import 'package:lumica_app/core/utils/validators.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/data/services/gemini_service.dart';
import 'package:lumica_app/domain/entities/note.dart';
import 'package:lumica_app/domain/entities/note_category.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class JournalController extends GetxController {
  final NoteRepository _noteRepository;
  final GeminiService _geminiService;

  // Debouncer for search input
  final Debouncer _searchDebouncer = Debouncer(
    delay: const Duration(milliseconds: 300),
  );

  JournalController({
    NoteRepository? noteRepository,
    GeminiService? geminiService,
  }) : _noteRepository = noteRepository ?? Get.find<NoteRepository>(),
       _geminiService = geminiService ?? GeminiService();

  // Observable list of all notes
  final RxList<Note> notes = <Note>[].obs;

  // Selected date for filtering
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Loading state - used for skeleton UI while LoadingUtil shows dialog
  final RxBool isLoading = false.obs;

  // Animation key for forcing animation replay on navigation
  final RxInt animationKey = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  @override
  void onClose() {
    _searchDebouncer.dispose();
    super.onClose();
  }

  Future<void> loadNotes() async {
    debugPrint('🚀 Starting loadNotes...');
    try {
      isLoading.value = true;
      // Removed LoadingUtil.show() to prevent stuck dialogs during navigation

      debugPrint('📡 Calling _noteRepository.getNotes()...');
      final result = await _noteRepository.getNotes();

      result.fold(
        (failure) {
          debugPrint('❌ Failed to load notes: ${failure.message}');
          AppSnackbar.error(failure.message, title: 'common.error'.tr);
          notes.clear();
        },
        (data) {
          debugPrint('✅ Notes loaded successfully: ${data.length} items');
          notes.assignAll(data);
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected crash in loadNotes: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      AppSnackbar.error('journal.loadFailed'.tr, title: 'common.error'.tr);
      // Do not clear notes on error to preserve potentially cached/existing data
    } finally {
      debugPrint('🏁 loadNotes finished.');
      isLoading.value = false;
      // Removed LoadingUtil.hide()
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

  // Create a new note with optimistic update
  Future<bool> createNote(Note note, {bool showSnackbar = true}) async {
    // Optimistic update: add to UI immediately
    notes.insert(0, note);
    setSelectedDate(note.createdAt);

    try {
      final result = await _noteRepository.createNote(note);
      return result.fold(
        (failure) {
          // Rollback on failure
          notes.removeWhere((n) => n.id == note.id);
          AppSnackbar.error(failure.message, title: 'common.error'.tr);
          return false;
        },
        (serverNote) {
          // Replace with server version (may have updated timestamps)
          final index = notes.indexWhere((n) => n.id == note.id);
          if (index != -1) {
            notes[index] = serverNote;
          }
          if (showSnackbar) {
            AppSnackbar.success('journal.noteCreated'.tr);
          }
          return true;
        },
      );
    } catch (e) {
      // Rollback on exception
      notes.removeWhere((n) => n.id == note.id);
      AppSnackbar.error('journal.createFailed'.tr, title: 'common.error'.tr);
      return false;
    }
  }

  // Update an existing note
  Future<bool> updateNote(Note updatedNote, {bool showSnackbar = true}) async {
    LoadingUtil.show(message: 'Updating note...');
    try {
      final result = await _noteRepository.updateNote(updatedNote);
      return result.fold(
        (failure) {
          AppSnackbar.error(failure.message, title: 'common.error'.tr);
          return false;
        },
        (note) {
          final index = notes.indexWhere((n) => n.id == note.id);
          if (index != -1) {
            notes[index] = note;
          }
          if (showSnackbar) {
            AppSnackbar.success('journal.noteUpdated'.tr);
          }
          return true;
        },
      );
    } catch (e) {
      AppSnackbar.error('journal.updateFailed'.tr, title: 'common.error'.tr);
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
          'journal.deleteConfirmTitle'.tr,
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
              'common.cancel'.tr,
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'common.delete'.tr,
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
          AppSnackbar.error(failure.message, title: 'common.error'.tr);
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
            AppSnackbar.success('journal.noteDeleted'.tr);
          } else {
            AppSnackbar.success('journal.noteDeleted'.tr);
          }
        },
      );
    } catch (e) {
      LoadingUtil.hide();
      AppSnackbar.error('journal.deleteFailed'.tr, title: 'common.error'.tr);
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
    // Validate input
    final validation = NoteValidator.validateNote(
      title: title.isEmpty ? 'Untitled' : title,
      content: contentJson,
    );

    if (!validation.isValid) {
      AppSnackbar.error(
        validation.message ?? 'Invalid note data',
        title: 'Validation Error',
      );
      return false;
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
        id: const Uuid().v4(), // Use UUID for consistency
        // Get generic user ID if not logged in (should usually not happen in this app structure)
        userId:
            Supabase.instance.client.auth.currentUser?.id ??
            '00000000-0000-0000-0000-000000000000',
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
        AppSnackbar.success('journal.noteSaved'.tr);
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

  // Set search query with debounce for performance
  void setSearchQuery(String query) {
    _searchDebouncer.run(() {
      searchQuery.value = query;
    });
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Generate AI Prompt for Journaling
  Future<String> generateAiPrompt() async {
    try {
      LoadingUtil.show(message: 'Consulting Lumica...');
      final prompt = await _geminiService.generateJournalPrompt();
      return prompt;
    } catch (e) {
      return "What are you grateful for right now?";
    } finally {
      LoadingUtil.hide();
    }
  }
}
