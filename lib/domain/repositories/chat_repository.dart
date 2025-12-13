import 'package:lumica_app/features/ai_chat/models/chat_message.dart';

/// Abstract interface for chat message persistence
/// Following Clean Architecture pattern for better testability and maintainability
abstract class ChatRepositoryInterface {
  /// Get all messages for the current user
  Future<List<ChatMessage>> getMessages();

  /// Save a single message to storage
  Future<void> saveMessage(ChatMessage message);

  /// Clear all chat history for the current user
  Future<void> clearChat();
}
