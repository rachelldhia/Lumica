import 'package:lumica_app/domain/entities/note_category.dart';

class Note {
  final String id;
  final String userId; // Added for Supabase database
  final String title;
  final String content;
  final NoteCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    NoteCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
