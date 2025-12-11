import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/domain/entities/note.dart';
import 'package:lumica_app/domain/entities/note_category.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onDelete,
  });

  /// Extracts plain text from Quill JSON content
  String _getPlainTextContent(String content) {
    try {
      // Try to parse as JSON (Quill format)
      final jsonContent = jsonDecode(content) as List;
      final buffer = StringBuffer();

      for (final op in jsonContent) {
        if (op is Map && op.containsKey('insert')) {
          final insert = op['insert'];
          if (insert is String) {
            buffer.write(insert);
          }
        }
      }

      return buffer.toString().trim();
    } catch (e) {
      // If parsing fails, return content as-is (might be plain text)
      return content.trim();
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    if (onDelete == null) return;
    // We assume onDelete is bound to logic, but now we prefer Controller.
    // However, NoteCard is stateless and 'onDelete' call implies parent handles it?
    // Looking at JournalPage usage:
    // `onDelete: () => controller.deleteNote(note.id)` was likely the old usage.
    // We should change JournalPage to pass `() => controller.promptDeleteNote(note.id, noteTitle: note.title)`
    // Or we can just invoke it here if we have access.
    // NoteCard doesn't inject Controller. It takes a callback.
    // So we just call the callback!
    // And let the PARENT (JournalPage) decide to call promptDeleteNote.

    // WAIT! The previous implementation was showing the dialog INSIDE NoteCard.
    // The user wants efficient refactor.
    // If I just call `onDelete!()`, then the dialog is gone?
    // Yes, that is the goal. NoteCard should just say "I was long pressed for delete".
    // The PARENT handles the UI flow.

    onDelete!();
  }

  @override
  Widget build(BuildContext context) {
    final plainTextContent = _getPlainTextContent(note.content);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteConfirmation(context),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: note.category.color,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              note.title,
              style: AppTextTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),

            // Content preview
            Text(
              plainTextContent.isEmpty ? 'No content' : plainTextContent,
              style: AppTextTheme.textTheme.bodySmall?.copyWith(
                color: AppColors.darkBrown.withValues(alpha: 0.8),
                height: 1.5,
              ),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
