import 'package:flutter/material.dart';
import 'package:lumica_app/core/config/theme.dart';

enum NoteCategory { productMeeting, toDoList, shopping, important, general }

extension NoteCategoryExtension on NoteCategory {
  String get displayName {
    switch (this) {
      case NoteCategory.productMeeting:
        return 'Product Meeting';
      case NoteCategory.toDoList:
        return 'To-do list';
      case NoteCategory.shopping:
        return 'Shopping list';
      case NoteCategory.important:
        return 'Important';
      case NoteCategory.general:
        return 'Notes';
    }
  }

  Color get color {
    switch (this) {
      case NoteCategory.productMeeting:
        return AppColors.skyBlue;
      case NoteCategory.toDoList:
        return const Color(0xFFE8D5F2); // Light purple/pink
      case NoteCategory.shopping:
        return const Color(0xFFFFF4D6); // Light yellow
      case NoteCategory.important:
        return const Color(0xFFD5F2E3); // Light green
      case NoteCategory.general:
        return AppColors.stoneGray.withValues(alpha: 0.3);
    }
  }

  String get filterLabel {
    switch (this) {
      case NoteCategory.productMeeting:
        return 'Lecture notes';
      case NoteCategory.toDoList:
        return 'To-do lists';
      case NoteCategory.shopping:
        return 'Shopping';
      case NoteCategory.important:
        return 'Important';
      case NoteCategory.general:
        return 'All';
    }
  }

  /// Convert string name to NoteCategory enum
  static NoteCategory fromName(String name) {
    switch (name.toLowerCase()) {
      case 'productmeeting':
        return NoteCategory.productMeeting;
      case 'todolist':
        return NoteCategory.toDoList;
      case 'shopping':
        return NoteCategory.shopping;
      case 'important':
        return NoteCategory.important;
      case 'general':
      default:
        return NoteCategory.general;
    }
  }
}
