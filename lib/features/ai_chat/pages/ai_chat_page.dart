import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/widgets/replayable_animated_list.dart';
import 'package:lumica_app/core/widgets/shimmer_widgets.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/features/ai_chat/models/chat_message.dart';
import 'package:lumica_app/features/ai_chat/widgets/ai_message_bubble.dart';
import 'package:lumica_app/features/ai_chat/widgets/animated_chat_message.dart';
import 'package:lumica_app/features/ai_chat/widgets/chat_app_bar.dart';
import 'package:lumica_app/features/ai_chat/widgets/chat_date_divider.dart';
import 'package:lumica_app/features/ai_chat/widgets/chat_empty_state.dart';
import 'package:lumica_app/features/ai_chat/widgets/chat_input_field.dart';
import 'package:lumica_app/features/ai_chat/widgets/emotion_update_bubble.dart';
import 'package:lumica_app/features/ai_chat/widgets/progress_update_bubble.dart';
import 'package:lumica_app/features/ai_chat/widgets/typing_indicator.dart';
import 'package:lumica_app/features/ai_chat/widgets/user_message_bubble.dart';

class AiChatPage extends GetView<AiChatController> {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const ChatAppBar(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isFetchingHistory.value) {
                  return _buildShimmerLoading();
                }

                if (controller.messages.isEmpty &&
                    !controller.isAiTyping.value) {
                  // Wrap with ReplayableAnimateWrapper to replay animation on tab switch
                  return ReplayableAnimateWrapper(
                    animationKey: controller.animationKey,
                    child: const ChatEmptyState(),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                      controller.messages.length +
                      (controller.isAiTyping.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show typing indicator at the end if loading
                    if (index == controller.messages.length &&
                        controller.isAiTyping.value) {
                      return const TypingIndicator()
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .slideY(begin: 0.2, end: 0);
                    }

                    final message = controller.messages[index];

                    // Show date divider if needed
                    final widgets = <Widget>[];
                    if (controller.shouldShowDateDivider(index)) {
                      widgets.add(
                        ChatDateDivider(
                          dateText: controller.formatDateDivider(
                            message.timestamp,
                          ),
                        ).animate().fadeIn(duration: 300.ms),
                      );
                    }

                    // Wrap message with optimized animation
                    // Animate last 5 messages for better visual continuity
                    final bool shouldAnimate =
                        index >= (controller.messages.length - 5);
                    final Widget messageWidget = _buildMessageWidget(message);

                    if (shouldAnimate) {
                      widgets.add(
                        AnimatedChatMessage(
                          isUser: message.type == MessageType.user,
                          index: controller.messages.length - index - 1,
                          child: messageWidget,
                        ),
                      );
                    } else {
                      widgets.add(messageWidget);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widgets,
                    );
                  },
                );
              }),
            ),
            // Suggested Replies Chips
            Obx(() {
              if (controller.isAiTyping.value ||
                  controller.suggestedReplies.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                height: 50.h,
                alignment: Alignment.centerLeft,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.suggestedReplies.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final suggestion = controller.suggestedReplies[index];
                    return ActionChip(
                          label: Text(
                            suggestion,
                            style: AppTextTheme.textTheme.bodySmall?.copyWith(
                              color: AppColors.darkBrown,
                            ),
                          ),
                          backgroundColor: AppColors.whiteColor,
                          elevation: 2,
                          shadowColor: AppColors.blackColor.withValues(
                            alpha: 0.1,
                          ),
                          surfaceTintColor: AppColors.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(
                              color: AppColors.vividOrange.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          onPressed: () =>
                              controller.startWithPrompt(suggestion),
                        )
                        .animate()
                        .fadeIn(delay: (index * 60).ms, duration: 250.ms)
                        .slideX(
                          begin: 0.15,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  },
                ),
              );
            }),
            Obx(
              () => ChatInputField(
                controller: controller.messageController,
                onSend: controller.sendMessage,
                onVoiceToggle: controller.toggleListening,
                isListening: controller.isListening.value,
                isDisabled: controller.isAiTyping.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageWidget(ChatMessage message) {
    switch (message.type) {
      case MessageType.user:
        return UserMessageBubble(
          message: message.content,
          avatarUrl: controller.userAvatarUrl.value,
          timestamp: message.timestamp,
        );
      case MessageType.ai:
        return AiMessageBubble(
          message: message.content,
          hasEmotionBadge: message.emotion != null,
          timestamp: message.timestamp,
        );
      case MessageType.emotionUpdate:
        return EmotionUpdateBubble(
          message: message.content,
          emotion: message.emotion,
        );
      case MessageType.progressUpdate:
        return ProgressUpdateBubble(message: message.content);
    }
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          // AI message shimmer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerCircle(size: 32.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: double.infinity,
                      height: 80.h,
                      borderRadius: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // User message shimmer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: ShimmerBox(
                  width: double.infinity,
                  height: 60.h,
                  borderRadius: 16,
                ),
              ),
              SizedBox(width: 12.w),
              ShimmerCircle(size: 32.w),
            ],
          ),
          SizedBox(height: 16.h),
          // AI message shimmer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerCircle(size: 32.w),
              SizedBox(width: 12.w),
              Expanded(
                child: ShimmerBox(
                  width: double.infinity,
                  height: 100.h,
                  borderRadius: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
