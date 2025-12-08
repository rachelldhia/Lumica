import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
import 'package:lumica_app/features/journal/models/note_category.dart';
import 'package:lumica_app/features/journal/widgets/note_card.dart';
import 'package:lumica_app/features/journal/pages/note_editor_page.dart';
import 'package:intl/intl.dart';

class JournalPage extends GetView<JournalController> {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Get.back(),
                    iconSize: 20.sp,
                    color: AppColors.darkBrown,
                  ),
                  SizedBox(width: 8.w),

                  // Title
                  Text(
                    'journal',
                    style: AppTextTheme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.darkSlateGray,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const Spacer(),

                  // Search icon
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // TODO: Implement search
                    },
                    iconSize: 24.sp,
                    color: AppColors.darkBrown,
                  ),
                ],
              ),
            ),

            // Calendar horizontal scroll
            SizedBox(
              height: 80.h,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final date = DateTime.now().subtract(
                      Duration(days: 3 - index),
                    );
                    final isSelected =
                        controller.selectedDate.value.day == date.day &&
                        controller.selectedDate.value.month == date.month;

                    return GestureDetector(
                      onTap: () => controller.setSelectedDate(date),
                      child: Container(
                        width: 60.w,
                        margin: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.vividOrange
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.vividOrange
                                : AppColors.stoneGray,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(date).substring(0, 3),
                              style: AppTextTheme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.darkSlateGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              date.day.toString(),
                              style: AppTextTheme.textTheme.titleLarge
                                  ?.copyWith(
                                    color: isSelected
                                        ? AppColors.whiteColor
                                        : AppColors.darkBrown,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              DateFormat('MMM').format(date),
                              style: AppTextTheme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.darkSlateGray,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Category filter chips
            SizedBox(
              height: 36.h,
              child: Obx(
                () => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    _buildCategoryChip('All', null),
                    SizedBox(width: 8.w),
                    _buildCategoryChip('Important', NoteCategory.important),
                    SizedBox(width: 8.w),
                    _buildCategoryChip(
                      'Lecture notes',
                      NoteCategory.productMeeting,
                    ),
                    SizedBox(width: 8.w),
                    _buildCategoryChip('To-do lists', NoteCategory.toDoList),
                    SizedBox(width: 8.w),
                    _buildCategoryChip('Shopping', NoteCategory.shopping),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Notes grid
            Expanded(
              child: Obx(() {
                final notes = controller.filteredNotes;

                if (notes.isEmpty) {
                  return Center(
                    child: Text(
                      'No notes yet',
                      style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.darkSlateGray,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onTap: () {
                        Get.to(
                          () => NoteEditorPage(noteId: note.id),
                          transition: Transition.rightToLeft,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      // FAB for creating new note
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => const NoteEditorPage(),
            transition: Transition.rightToLeft,
          );
        },
        backgroundColor: AppColors.vividOrange,
        child: Icon(Icons.add, color: AppColors.whiteColor, size: 28.sp),
      ),
    );
  }

  Widget _buildCategoryChip(String label, NoteCategory? category) {
    final isSelected = controller.selectedCategory.value == category;

    return GestureDetector(
      onTap: () => controller.setCategoryFilter(category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBrown : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.darkBrown
                : AppColors.darkSlateGray.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextTheme.textTheme.bodySmall?.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.darkSlateGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
