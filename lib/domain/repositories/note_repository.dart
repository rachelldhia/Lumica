import 'package:either_dart/either.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/domain/entities/note.dart';

/// Note repository interface
abstract class NoteRepository {
  /// Get all notes for current user
  Future<Either<Failure, List<Note>>> getNotes();

  /// Get a single note by ID
  Future<Either<Failure, Note>> getNoteById(String noteId);

  /// Create a new note
  Future<Either<Failure, Note>> createNote(Note note);

  /// Update existing note
  Future<Either<Failure, Note>> updateNote(Note note);

  /// Delete note
  Future<Either<Failure, void>> deleteNote(String noteId);
}
