import 'package:get/get.dart';
import 'package:lumica_app/features/journal/models/note_model.dart';
import 'package:lumica_app/features/journal/models/note_category.dart';

class JournalController extends GetxController {
  // Observable list of all notes
  final RxList<Note> notes = <Note>[].obs;

  // Selected date for filtering
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Selected category filter (null means "All")
  final Rx<NoteCategory?> selectedCategory = Rx<NoteCategory?>(null);

  // Search query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleNotes(); // Load sample notes for demo
  }

  // Get filtered notes based on category and search
  List<Note> get filteredNotes {
    var result = notes.where((note) {
      // Filter by category
      if (selectedCategory.value != null &&
          note.category != selectedCategory.value) {
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

  // Create a new note
  void createNote(Note note) {
    notes.add(note);
  }

  // Update an existing note
  void updateNote(Note updatedNote) {
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
    }
  }

  // Delete a note
  void deleteNote(String noteId) {
    notes.removeWhere((note) => note.id == noteId);
  }

  // Get a note by ID
  Note? getNoteById(String id) {
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Set category filter
  void setCategoryFilter(NoteCategory? category) {
    selectedCategory.value = category;
  }

  // Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Load sample notes for demonstration
  void _loadSampleNotes() {
    final now = DateTime.now();

    notes.addAll([
      Note(
        id: '1',
        title: 'Product Meeting',
        content:
            '''Product management is a strategic role within a company that involves overseeing the development and management of a product or suite of products throughout their lifecycle. The primary goal of a product manager is to create and deliver products that meet customer needs, align with business objectives, and generate value for the organization.

1. Market research and analysis: Product managers conduct market research to understand customer needs, preferences, and trends. They analyze market data and competitive landscape to identify opportunities and make informed product decisions.

2. Product strategy: Product managers define the product vision, goals, and strategy based on market research and business objectives!''',
        category: NoteCategory.productMeeting,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Note(
        id: '2',
        title: 'To-do list',
        content: '''1. Reply to the email
2. Prepare presentation slides for the meeting
3. Conduct research on competitor products
4. Schedule and plan product roadmap
5. Finalize mockups and wireframes for the new feature
6. Check budget and recharge''',
        category: NoteCategory.toDoList,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      Note(
        id: '3',
        title: 'Shopping list',
        content: '''1. Rice
2. Pasta
3. Carrot
4. Tomato
5. Cheese
6. Butter''',
        category: NoteCategory.shopping,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
      Note(
        id: '4',
        title: 'Important',
        content:
            '''• Summarize the key action items identified during the meeting.
• Assign responsibilities and set deadlines for each task.
• Clearly outline next steps to ensure everyone is aligned.
• Clarify the next or upcoming milestones for respective tasks.''',
        category: NoteCategory.important,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Note(
        id: '5',
        title: 'Notes',
        content: '''• Clean keyboard and mouse''',
        category: NoteCategory.general,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
    ]);
  }
}
