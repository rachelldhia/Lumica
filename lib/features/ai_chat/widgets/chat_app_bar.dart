import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/features/ai_chat/widgets/delete_conversation_dialog.dart';

class ChatAppBar extends GetView<AiChatController>
    implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.vividOrange, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(AppImages.lumiRobot, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'aiChat.lumi'.tr,
            style: AppTextTheme.textTheme.titleLarge?.copyWith(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        Obx(() {
          final availableDates = controller.getAvailableDates();
          if (availableDates.isEmpty) {
            return const SizedBox.shrink();
          }

          return PopupMenuButton<DateTime?>(
            icon: Image.asset(
              AppIcon.dateRange,
              width: 22.w,
              height: 22.h,
              color: AppColors.darkBrown,
            ),
            tooltip: 'aiChat.filterByDate'.tr,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            offset: Offset(0, 50.h),
            itemBuilder: (context) {
              return [
                PopupMenuItem<DateTime?>(
                  value: null,
                  child: Row(
                    children: [
                      Image.asset(
                        AppIcon.cancle,
                        width: 18.w,
                        height: 18.h,
                        color: AppColors.darkSlateGray,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'aiChat.showAll'.tr,
                        style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                ...availableDates.map((date) {
                  final isSelected =
                      controller.selectedDate.value != null &&
                      controller.selectedDate.value!.year == date.year &&
                      controller.selectedDate.value!.month == date.month &&
                      controller.selectedDate.value!.day == date.day;

                  return PopupMenuItem<DateTime?>(
                    value: date,
                    child: Row(
                      children: [
                        Image.asset(
                          isSelected ? AppIcon.checkRound : AppIcon.cancle,
                          width: 18.w,
                          height: 18.h,
                          color: isSelected
                              ? AppColors.vividOrange
                              : Colors.transparent,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          _formatDate(date),
                          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ];
            },
            onSelected: (date) {
              controller.filterByDate(date);
            },
          );
        }),
        Obx(() {
          if (controller.messages.isEmpty) {
            return const SizedBox.shrink();
          }

          return IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: AppColors.darkBrown,
              size: 22.sp,
            ),
            tooltip: 'aiChat.clearChat'.tr,
            onPressed: () => _showDeleteDialog(context),
          );
        }),
        SizedBox(width: 8.w),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'aiChat.today'.tr;
    } else if (messageDate == yesterday) {
      return 'aiChat.yesterday'.tr;
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      DeleteConversationDialog(
        onConfirm: () {
          Get.find<AiChatController>().clearChat();
          AppSnackbar.success(
            'aiChat.conversationDeleted'.tr,
            title: 'common.success'.tr,
          );
        },
      ),
    );
  }
}
