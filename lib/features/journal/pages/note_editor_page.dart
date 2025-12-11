import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
import 'package:lumica_app/domain/entities/note_category.dart';
import 'package:lumica_app/domain/entities/note.dart';

class NoteEditorPage extends StatefulWidget {
  final String? noteId;

  const NoteEditorPage({super.key, this.noteId});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final controller = Get.find<JournalController>();
  final titleController = TextEditingController();
  late QuillController quillController;
  final focusNode = FocusNode();

  late Rx<NoteCategory> selectedCategory;
  Note? editingNote;
  // _canPop removed - delegated to controller

  // Track active format states
  final RxBool _isBoldActive = false.obs;
  final RxBool _isItalicActive = false.obs;
  final RxBool _isUnderlineActive = false.obs;
  final RxBool _isStrikeThroughActive = false.obs;
  final RxBool _isBulletListActive = false.obs;
  final RxBool _isNumberListActive = false.obs;

  @override
  void initState() {
    super.initState();
    _initializeEditor();
  }

  void _initializeEditor() {
    selectedCategory = NoteCategory.general.obs;

    if (widget.noteId != null) {
      editingNote = controller.getNoteById(widget.noteId!);
      if (editingNote != null) {
        titleController.text = editingNote!.title;
        selectedCategory.value = editingNote!.category;
        _loadContentIntoQuill(editingNote!.content);
      } else {
        quillController = QuillController.basic();
      }
    } else {
      quillController = QuillController.basic();
    }

    // Add listener to track format changes
    quillController.addListener(_updateToolbarState);
  }

  void _loadContentIntoQuill(String content) {
    try {
      final jsonContent = jsonDecode(content) as List;
      final doc = Document.fromJson(jsonContent);
      quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      quillController = QuillController.basic();
      if (content.isNotEmpty) {
        quillController.document.insert(0, content);
      }
    }
  }

  void _updateToolbarState() {
    final style = quillController.getSelectionStyle();

    _isBoldActive.value = style.attributes.containsKey(Attribute.bold.key);
    _isItalicActive.value = style.attributes.containsKey(Attribute.italic.key);
    _isUnderlineActive.value = style.attributes.containsKey(
      Attribute.underline.key,
    );
    _isStrikeThroughActive.value = style.attributes.containsKey(
      Attribute.strikeThrough.key,
    );

    // Check for list attributes
    final blockAttr = style.attributes[Attribute.list.key];
    _isBulletListActive.value = blockAttr?.value == Attribute.ul.value;
    _isNumberListActive.value = blockAttr?.value == Attribute.ol.value;
  }

  @override
  void dispose() {
    quillController.removeListener(_updateToolbarState);
    titleController.dispose();
    quillController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _toggleFormat(Attribute attribute, RxBool isActive) {
    if (isActive.value) {
      // Turn off: use the "clone" attribute with null value to remove
      if (attribute == Attribute.bold) {
        quillController.formatSelection(Attribute.clone(Attribute.bold, null));
      } else if (attribute == Attribute.italic) {
        quillController.formatSelection(
          Attribute.clone(Attribute.italic, null),
        );
      } else if (attribute == Attribute.underline) {
        quillController.formatSelection(
          Attribute.clone(Attribute.underline, null),
        );
      } else if (attribute == Attribute.strikeThrough) {
        quillController.formatSelection(
          Attribute.clone(Attribute.strikeThrough, null),
        );
      } else if (attribute == Attribute.ul || attribute == Attribute.ol) {
        quillController.formatSelection(Attribute.clone(Attribute.list, null));
      }
    } else {
      // Turn on
      quillController.formatSelection(attribute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Always intercept back to handle saving
      // ignore: use_build_context_synchronously
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Delegate to controller
        final contentJson = jsonEncode(
          quillController.document.toDelta().toJson(),
        );

        await controller.saveAndClose(
          id: widget.noteId,
          title: titleController.text,
          contentJson: contentJson,
          category: selectedCategory.value,
          existingNote: editingNote,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTitleField(),
            Divider(
              height: 1.h,
              thickness: 1,
              color: AppColors.stoneGray.withValues(alpha: 0.2),
            ),
            Expanded(child: _buildEditor()),
            _buildToolbar(),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    // Delegate entirely to controller
    // This handles Dialog -> Loading -> Delete -> Navigation safely
    if (widget.noteId != null) {
      controller.promptDeleteNote(
        widget.noteId!,
        noteTitle: titleController.text,
        closePage: true,
      );
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.darkBrown,
          size: 20.sp,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        // Delete button (only show when editing existing note)
        if (widget.noteId != null)
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
            onPressed: _showDeleteConfirmation,
          ),
        _buildCategorySelector(),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Obx(
      () => PopupMenuButton<NoteCategory>(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: selectedCategory.value.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.folder_outlined,
            color: AppColors.vividOrange,
            size: 20.sp,
          ),
        ),
        onSelected: (category) {
          selectedCategory.value = category;
        },
        itemBuilder: (context) => NoteCategory.values.map((category) {
          final isSelected = selectedCategory.value == category;
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
                    border: isSelected
                        ? Border.all(color: AppColors.vividOrange, width: 2)
                        : null,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  category.displayName,
                  style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkBrown,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: TextField(
        controller: titleController,
        decoration: InputDecoration(
          hintText: 'Title',
          hintStyle: AppTextTheme.textTheme.headlineSmall?.copyWith(
            color: AppColors.darkSlateGray.withValues(alpha: 0.4),
            fontSize: 26.sp,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: AppTextTheme.textTheme.headlineSmall?.copyWith(
          color: AppColors.darkBrown,
          fontSize: 26.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBrown,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildToolbarButton(
                icon: Icons.format_bold,
                attribute: Attribute.bold,
                isActive: _isBoldActive,
              ),
              _buildToolbarButton(
                icon: Icons.format_italic,
                attribute: Attribute.italic,
                isActive: _isItalicActive,
              ),
              _buildToolbarButton(
                icon: Icons.format_underline,
                attribute: Attribute.underline,
                isActive: _isUnderlineActive,
              ),
              _buildToolbarButton(
                icon: Icons.format_strikethrough,
                attribute: Attribute.strikeThrough,
                isActive: _isStrikeThroughActive,
              ),
              SizedBox(
                height: 24.h,
                child: VerticalDivider(
                  color: AppColors.whiteColor.withValues(alpha: 0.3),
                  thickness: 1,
                  width: 16.w,
                ),
              ),
              _buildToolbarButton(
                icon: Icons.format_list_bulleted,
                attribute: Attribute.ul,
                isActive: _isBulletListActive,
              ),
              _buildToolbarButton(
                icon: Icons.format_list_numbered,
                attribute: Attribute.ol,
                isActive: _isNumberListActive,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required Attribute attribute,
    required RxBool isActive,
  }) {
    return Obx(() {
      final active = isActive.value;
      return GestureDetector(
        onTap: () => _toggleFormat(attribute, isActive),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.all(8.w),
          constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
          decoration: BoxDecoration(
            color: active
                ? AppColors.vividOrange.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: active ? AppColors.vividOrange : AppColors.whiteColor,
            size: 20.sp,
          ),
        ),
      );
    });
  }

  Widget _buildEditor() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: QuillEditor.basic(
        controller: quillController,
        config: QuillEditorConfig(
          padding: EdgeInsets.zero,
          scrollable: true,
          autoFocus: false,
          placeholder: 'Start writing...',
          expands: false,
        ),
      ),
    );
  }
}
