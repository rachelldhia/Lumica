import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
import 'package:lumica_app/features/journal/models/note_model.dart';
import 'package:lumica_app/features/journal/models/note_category.dart';
import 'package:lumica_app/features/journal/models/text_format.dart';
import 'package:lumica_app/features/journal/widgets/text_formatting_toolbar.dart';

class NoteEditorPage extends StatefulWidget {
  final String? noteId;

  const NoteEditorPage({super.key, this.noteId});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final controller = Get.find<JournalController>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final focusNode = FocusNode();

  late Rx<NoteCategory> selectedCategory;
  late Rx<TextFormat> textFormat;
  Note? editingNote;

  @override
  void initState() {
    super.initState();

    // Initialize with default values
    selectedCategory = NoteCategory.general.obs;
    textFormat = const TextFormat().obs;

    // If editing existing note, load it
    if (widget.noteId != null) {
      editingNote = controller.getNoteById(widget.noteId!);
      if (editingNote != null) {
        titleController.text = editingNote!.title;
        contentController.text = editingNote!.content;
        selectedCategory.value = editingNote!.category;
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (titleController.text.isEmpty && contentController.text.isEmpty) {
      Get.back();
      return;
    }

    final now = DateTime.now();

    if (editingNote != null) {
      // Update existing note
      final updatedNote = editingNote!.copyWith(
        title: titleController.text.isEmpty ? 'Untitled' : titleController.text,
        content: contentController.text,
        category: selectedCategory.value,
        updatedAt: now,
      );
      controller.updateNote(updatedNote);
    } else {
      // Create new note
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.isEmpty ? 'Untitled' : titleController.text,
        content: contentController.text,
        category: selectedCategory.value,
        createdAt: now,
        updatedAt: now,
      );
      controller.createNote(newNote);
    }

    Get.back();
  }

  void _applyFormatting(TextFormat newFormat) {
    textFormat.value = newFormat;
    // In a real implementation, you would apply this to selected text
    // For simplicity, we're just tracking the format state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.darkBrown,
            size: 20.sp,
          ),
          onPressed: _saveNote,
        ),
        actions: [
          // Category selector icon
          Obx(
            () => PopupMenuButton<NoteCategory>(
              icon: Icon(
                Icons.folder_outlined,
                color: AppColors.vividOrange,
                size: 24.sp,
              ),
              onSelected: (category) {
                selectedCategory.value = category;
              },
              itemBuilder: (context) => NoteCategory.values.map((category) {
                return PopupMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        category.displayName,
                        style: AppTextTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Favorite/bookmark icon
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: AppColors.vividOrange,
              size: 24.sp,
            ),
            onPressed: () {},
          ),

          // Share icon
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: AppColors.vividOrange,
              size: 24.sp,
            ),
            onPressed: () {},
          ),

          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Content area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),

                  // Title input
                  TextField(
                    controller: titleController,
                    style: AppTextTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBrown,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: AppTextTheme.textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkSlateGray.withValues(
                              alpha: 0.3,
                            ),
                          ),
                      border: InputBorder.none,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Content input with formatting
                  Obx(
                    () => TextField(
                      controller: contentController,
                      focusNode: focusNode,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkBrown,
                        height: 1.6,
                        fontWeight: textFormat.value.isBold
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontStyle: textFormat.value.isItalic
                            ? FontStyle.italic
                            : FontStyle.normal,
                        decoration: textFormat.value.isUnderline
                            ? TextDecoration.underline
                            : (textFormat.value.isStrikethrough
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                      ),
                      textAlign: textFormat.value.alignment,
                      decoration: InputDecoration(
                        hintText: 'Start typing...',
                        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkSlateGray.withValues(alpha: 0.4),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 100.h), // Extra space for toolbar
                ],
              ),
            ),
          ),

          // Text formatting toolbar
          Obx(
            () => TextFormattingToolbar(
              currentFormat: textFormat.value,
              onFormatChanged: _applyFormatting,
            ),
          ),
        ],
      ),
    );
  }
}
