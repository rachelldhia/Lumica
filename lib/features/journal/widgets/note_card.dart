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

  /// Extracts plain text from Quill JSON content with basic formatting
  String _getPlainTextContent(String content) {
    try {
      if (content.isEmpty) return '';
      final jsonContent = jsonDecode(content) as List;
      final buffer = StringBuffer();
      final currentLine = StringBuffer();
      int orderedListIndex = 0;

      for (final op in jsonContent) {
        if (op is Map && op.containsKey('insert')) {
          final insert = op['insert'];
          final attributes = op['attributes'] as Map<String, dynamic>?;

          if (insert is String) {
            for (int i = 0; i < insert.length; i++) {
              final char = insert[i];
              if (char == '\n') {
                // End of line, process attributes
                String prefix = '';
                bool isOrdered = false;

                if (attributes != null) {
                  if (attributes['list'] == 'bullet') {
                    prefix = '• ';
                  } else if (attributes['list'] == 'ordered') {
                    orderedListIndex++;
                    prefix = '$orderedListIndex. ';
                    isOrdered = true;
                  } else if (attributes['list'] == 'checked') {
                    prefix = '[x] ';
                  } else if (attributes['list'] == 'unchecked') {
                    prefix = '[ ] ';
                  }
                }

                if (!isOrdered) {
                  orderedListIndex = 0;
                }

                buffer.write('$prefix$currentLine\n');
                currentLine.clear();
              } else {
                currentLine.write(char);
              }
            }
          }
        }
      }

      // Append any remaining text
      if (currentLine.isNotEmpty) {
        buffer.write(currentLine.toString());
      }

      return buffer.toString().trim();
    } catch (e) {
      // If parsing fails, return content as-is (might be plain text)
      return content.trim();
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    if (onDelete == null) return;
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
