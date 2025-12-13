import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/shimmer_widgets.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/features/ai_chat/models/chat_message.dart';
import 'package:lumica_app/features/ai_chat/widgets/ai_message_bubble.dart';
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
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
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

                if (controller.messages.isEmpty &&
                    !controller.isAiTyping.value) {
                  return const ChatEmptyState();
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
                      return const TypingIndicator();
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
                        ),
                      );
                    }

                    widgets.add(_buildMessageWidget(message));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widgets,
                    );
                  },
                );
              }),
            ),
            Obx(
              () => ChatInputField(
                controller: controller.messageController,
                onSend: controller.sendMessage,
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
        );
      case MessageType.ai:
        return AiMessageBubble(
          message: message.content,
          hasEmotionBadge: message.emotion != null,
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
}
