import 'package:either_dart/either.dart';
import 'package:lumica_app/core/errors/exceptions.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/data/datasources/note_remote_datasource.dart';
import 'package:lumica_app/domain/entities/note.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource _remoteDataSource;

  NoteRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final notes = await _remoteDataSource.getNotes();
      return Right(notes);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String noteId) async {
    try {
      final note = await _remoteDataSource.getNoteById(noteId);
      return Right(note);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      final createdNote = await _remoteDataSource.createNote(note);
      return Right(createdNote);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final updatedNote = await _remoteDataSource.updateNote(note);
      return Right(updatedNote);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String noteId) async {
    try {
      await _remoteDataSource.deleteNote(noteId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
