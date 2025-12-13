import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/domain/entities/note.dart';
import 'package:lumica_app/domain/entities/note_category.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const NoteCard({
    super.key,
    required this.note,
    this.backgroundColor,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isPressed = false;

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
    if (widget.onDelete == null) return;
    widget.onDelete!();
  }

  @override
  Widget build(BuildContext context) {
    final plainTextContent = _getPlainTextContent(widget.note.content);

    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        onLongPress: widget.onDelete != null
            ? () => _showDeleteConfirmation(context)
            : null,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? widget.note.category.color,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.note.title,
                style: AppTextTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBrown,
                  fontSize: 16.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),

              // Content preview
              Expanded(
                child: Text(
                  plainTextContent.isEmpty ? 'No content' : plainTextContent,
                  style: AppTextTheme.textTheme.bodySmall?.copyWith(
                    color: AppColors.darkBrown.withValues(alpha: 0.75),
                    height: 1.6,
                    fontSize: 13.sp,
                  ),
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
