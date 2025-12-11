import 'package:either_dart/either.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';
import 'package:lumica_app/domain/entities/note_category.dart';
import 'package:lumica_app/domain/entities/note.dart';

class NoteRepositoryImpl implements NoteRepository {
  // Simulating a data source with an in-memory list
  final List<Note> _notes = [];

  NoteRepositoryImpl() {
    _loadSampleNotes();
  }

  void _loadSampleNotes() {
    final now = DateTime.now();

    _notes.addAll([
      Note(
        id: '1',
        userId: '00000000-0000-0000-0000-000000000000',
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
        userId: '00000000-0000-0000-0000-000000000000',
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
        userId: '00000000-0000-0000-0000-000000000000',
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
        userId: '00000000-0000-0000-0000-000000000000',
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
        userId: '00000000-0000-0000-0000-000000000000',
        title: 'Notes',
        content: '''• Clean keyboard and mouse''',
        category: NoteCategory.general,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(_notes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String noteId) async {
    try {
      final note = _notes.firstWhere(
        (note) => note.id == noteId,
        orElse: () => throw Exception('Note not found'),
      );
      return Right(note);
    } catch (e) {
      return Left(NotFoundFailure('Note with id $noteId not found'));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      _notes.add(note);
      return Right(note);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        return Right(note);
      } else {
        return const Left(NotFoundFailure('Note not found for update'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String noteId) async {
    try {
      // Simulate network delay (matching getNotes)
      await Future.delayed(const Duration(milliseconds: 500));
      _notes.removeWhere((note) => note.id == noteId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
