import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
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
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            //   child: Text(
            //     'Journal',
            //     style: AppTextTheme.textTheme.headlineSmall?.copyWith(
            //       color: AppColors.darkSlateGray,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),

            // Calendar horizontal scroll - only show dates with notes
            Obx(() {
              // Show skeleton during initial load
              if (controller.notes.isEmpty && controller.isLoading.value) {
                return SizedBox(height: 12.h);
              }

              final datesWithNotes = controller.getDatesWithNotes;

              if (datesWithNotes.isEmpty) {
                return SizedBox(height: 12.h);
              }

              return SizedBox(
                height: 100.h, // Increased height for better touch target
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: datesWithNotes.length,
                  itemBuilder: (context, index) {
                    final date = datesWithNotes[index];

                    // Wrap each item in Obx for reactive selection
                    return Obx(() {
                      final isSelected =
                          controller.selectedDate.value.day == date.day &&
                          controller.selectedDate.value.month == date.month &&
                          controller.selectedDate.value.year == date.year;

                      return GestureDetector(
                        onTap: () => controller.setSelectedDate(date),
                        child: Container(
                          width: 70.w, // Increased width
                          margin: EdgeInsets.symmetric(
                            horizontal: 6.w, // Increased margin
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.vividOrange
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(
                              16.r,
                            ), // Increased radius
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.vividOrange
                                  : AppColors.stoneGray,
                              width: 2, // Increased border width
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.vividOrange.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('EEE').format(date).substring(0, 3),
                                style: AppTextTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                      // Changed from bodySmall
                                      color: isSelected
                                          ? AppColors.whiteColor
                                          : AppColors.darkSlateGray,
                                      fontWeight:
                                          FontWeight.w600, // Increased weight
                                    ),
                              ),
                              SizedBox(height: 6.h), // Increased spacing
                              Text(
                                date.day.toString(),
                                style: AppTextTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                      // Changed from titleLarge
                                      color: isSelected
                                          ? AppColors.whiteColor
                                          : AppColors.darkBrown,
                                      fontWeight:
                                          FontWeight.w700, // Increased weight
                                    ),
                              ),
                              Text(
                                DateFormat('MMM').format(date),
                                style: AppTextTheme.textTheme.bodySmall
                                    ?.copyWith(
                                      color: isSelected
                                          ? AppColors.whiteColor
                                          : AppColors.darkSlateGray,
                                      fontSize: 11.sp, // Increased from 10.sp
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              );
            }),

            SizedBox(height: 20.h), // Increased spacing
            // Notes grid
            Expanded(
              child: Obx(() {
                // Show skeleton during initial load
                if (controller.notes.isEmpty && controller.isLoading.value) {
                  return const SizedBox.shrink();
                }

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
                      onDelete: () async {
                        // All delete logic (confirmation + loading + delete) is now in controller
                        await controller.promptDeleteNote(
                          note.id,
                          noteTitle: note.title,
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
}
