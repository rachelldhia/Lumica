import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/domain/repositories/chat_repository.dart';
import 'package:lumica_app/features/ai_chat/models/chat_message.dart';

/// Implementation of ChatRepository interface for Supabase backend
/// Handles all chat message persistence operations
class ChatRepositoryImpl implements ChatRepositoryInterface {
  final SupabaseClient _supabase;

  ChatRepositoryImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<ChatMessage>> getMessages() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ User not logged in, cannot fetch messages');
        return [];
      }

      // Limit to last 200 messages to prevent memory issues
      final response = await _supabase
          .from('chats')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(200);

      final messages = (response as List)
          .map((e) => ChatMessage.fromJson(e))
          .toList();

      // Reverse to get chronological order
      return messages.reversed.toList();
    } catch (e) {
      debugPrint('❌ Error fetching messages: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ User not logged in, cannot save message');
        return;
      }

      await _supabase.from('chats').insert({
        ...message.toJson(),
        'user_id': userId,
      });
    } catch (e) {
      debugPrint('❌ Error saving message: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearChat() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase.from('chats').delete().eq('user_id', userId);
    } catch (e) {
      debugPrint('❌ Error clearing chat: $e');
      rethrow;
    }
  }
}
