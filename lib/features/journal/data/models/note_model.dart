import 'package:lumica_app/domain/entities/note.dart';
import 'package:lumica_app/domain/entities/note_category.dart';

class NoteModel extends Note {
  NoteModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    required super.category,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: NoteCategoryExtension.fromName(json['category'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'category': category.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      userId: note.userId,
      title: note.title,
      content: note.content,
      category: note.category,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }
}
