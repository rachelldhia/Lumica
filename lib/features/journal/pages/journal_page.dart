import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/app_states.dart';
import 'package:lumica_app/core/widgets/replayable_animated_list.dart';
import 'package:lumica_app/core/widgets/shimmer_widgets.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
import 'package:lumica_app/features/journal/widgets/note_card.dart';
import 'package:lumica_app/features/journal/pages/note_editor_page.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final controller = Get.find<JournalController>();
  bool _isFabPressed = false;
  final RxBool _isSearchMode = false.obs;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    _isSearchMode.value = !_isSearchMode.value;
    if (!_isSearchMode.value) {
      _searchController.clear();
      controller.setSearchQuery('');
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL: Use Navigator.canPop to check navigation stack depth
    // Get.previousRoute becomes unreliable after returning from NoteEditorPage
    // because both previousRoute and currentRoute become '/dashboard/journal'
    // Navigator.canPop correctly checks if there's a route to pop to
    final showBackButton = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () => controller.loadNotes(),
          child: Column(
            children: [
              // Header with conditional back button and search
              Obx(
                () => _isSearchMode.value
                    ? _buildSearchHeader()
                    : _buildNormalHeader(showBackButton),
              ),
              // Calendar horizontal scroll
              Obx(() {
                if (controller.notes.isEmpty && controller.isLoading.value) {
                  return SizedBox(height: 12.h);
                }

                final datesWithNotes = controller.getDatesWithNotes;

                if (datesWithNotes.isEmpty) {
                  return SizedBox(height: 12.h);
                }

                return SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    itemCount: datesWithNotes.length,
                    itemBuilder: (context, index) {
                      final date = datesWithNotes[index];

                      return Obx(() {
                        final isSelected =
                            controller.selectedDate.value.day == date.day &&
                            controller.selectedDate.value.month == date.month &&
                            controller.selectedDate.value.year == date.year;

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () => controller.setSelectedDate(date),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  width: 70.w,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.vividOrange
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.vividOrange
                                          : AppColors.stoneGray,
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.vividOrange
                                                  .withValues(alpha: 0.3),
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
                                        DateFormat(
                                          'EEE',
                                        ).format(date).substring(0, 3),
                                        style: AppTextTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: isSelected
                                                  ? AppColors.whiteColor
                                                  : AppColors.darkSlateGray,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        date.day.toString(),
                                        style: AppTextTheme
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: isSelected
                                                  ? AppColors.whiteColor
                                                  : AppColors.darkBrown,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      Text(
                                        DateFormat('MMM').format(date),
                                        style: AppTextTheme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: isSelected
                                                  ? AppColors.whiteColor
                                                  : AppColors.darkSlateGray,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                );
              }),

              SizedBox(height: 24.h),

              // Notes grid
              Expanded(
                child: Obx(() {
                  if (controller.notes.isEmpty && controller.isLoading.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.75,
                        children: List.generate(
                          4,
                          (index) => ShimmerBox(
                            width: double.infinity,
                            height: 200.h,
                            borderRadius: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  final notes = controller.filteredNotes;

                  if (notes.isEmpty) {
                    return const AppEmptyState(
                      title: 'No notes yet',
                      subtitle: 'Start journaling your thoughts',
                      icon: Icons.book_outlined,
                    );
                  }

                  // Use ReplayableAnimatedList for animation replay on tab switch
                  return ReplayableAnimatedList(
                    animationKey: controller.animationKey,
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        final colors = [
                          const Color(0xFFB3D9FF),
                          const Color(0xFFFFD9E6),
                          const Color(0xFFFFF4CC),
                          const Color(0xFFD4F4DD),
                        ];

                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          duration: const Duration(milliseconds: 450),
                          child: SlideAnimation(
                            verticalOffset: 30.0,
                            curve: Curves.easeOutCubic,
                            child: ScaleAnimation(
                              scale: 0.9,
                              curve: Curves.easeOutBack,
                              child: FadeInAnimation(
                                child: Hero(
                                  tag: 'note-${note.id}',
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: NoteCard(
                                      note: note,
                                      backgroundColor:
                                          colors[index % colors.length],
                                      onTap: () {
                                        Get.to(
                                          () => NoteEditorPage(noteId: note.id),
                                          transition: Transition.rightToLeft,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                        );
                                      },
                                      onDelete: () async {
                                        await controller.promptDeleteNote(
                                          note.id,
                                          noteTitle: note.title,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      // FAB for creating new note
      floatingActionButton: AnimatedScale(
        scale: _isFabPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isFabPressed = true),
          onTapUp: (_) {
            setState(() => _isFabPressed = false);
            Future.delayed(const Duration(milliseconds: 100), () {
              Get.to(
                () => const NoteEditorPage(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            });
          },
          onTapCancel: () => setState(() => _isFabPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: AppColors.darkBrown,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBrown.withValues(
                    alpha: _isFabPressed ? 0.5 : 0.3,
                  ),
                  blurRadius: _isFabPressed ? 16 : 12,
                  spreadRadius: _isFabPressed ? 3 : 2,
                  offset: Offset(0, _isFabPressed ? 6 : 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.add, color: AppColors.whiteColor, size: 28.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalHeader(bool showBackButton) {
    if (!showBackButton) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.darkBrown,
              size: 20.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Journal',
              style: AppTextTheme.textTheme.headlineMedium?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(Icons.search, color: AppColors.darkBrown, size: 24.sp),
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.darkBrown,
              size: 24.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (value) => controller.setSearchQuery(value),
              style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                color: AppColors.darkBrown,
              ),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkBrown.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                controller.setSearchQuery('');
              },
              icon: Icon(Icons.clear, color: AppColors.darkBrown, size: 20.sp),
            ),
        ],
      ),
    );
  }
}
