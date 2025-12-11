import 'package:flutter/foundation.dart';
import 'package:lumica_app/core/errors/exceptions.dart';
import 'package:lumica_app/domain/entities/note.dart';
import 'package:lumica_app/features/journal/data/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteRemoteDataSource {
  final SupabaseClient _supabase;

  NoteRemoteDataSource(this._supabase);

  Future<List<Note>> getNotes() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      debugPrint('🔍 Fetching notes for user: $userId');

      final response = await _supabase
          .from('journals')
          .select()
          .eq('user_id', userId!)
          .order('created_at', ascending: false);

      debugPrint('✅ Raw notes fetched: ${(response as List).length} items');

      return (response as List)
          .map((json) => NoteModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      debugPrint('❌ PostgrestException in getNotes: ${e.message}');
      debugPrint('Error code: ${e.code}');
      debugPrint('Error details: ${e.details}');
      throw ServerException(e.message);
    } catch (e) {
      debugPrint('❌ Unexpected error in getNotes: $e');
      throw ServerException(e.toString());
    }
  }

  Future<Note> getNoteById(String id) async {
    try {
      final response = await _supabase
          .from('journals')
          .select()
          .eq('id', id)
          .single();

      return NoteModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Note> createNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);

      final response = await _supabase
          .from('journals')
          .insert({
            'user_id': _supabase.auth.currentUser!.id,
            'title': noteModel.title,
            'content': noteModel.content,
            'category': noteModel.category.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return NoteModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Note> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);

      final response = await _supabase
          .from('journals')
          .update({
            'title': noteModel.title,
            'content': noteModel.content,
            'category': noteModel.category.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', noteModel.id)
          .select()
          .single();

      return NoteModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _supabase.from('journals').delete().eq('id', noteId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
