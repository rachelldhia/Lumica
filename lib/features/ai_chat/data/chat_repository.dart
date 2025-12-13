import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/domain/repositories/chat_repository.dart';
import '../models/chat_message.dart';

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

      final response = await _supabase
          .from('chats')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List).map((e) => ChatMessage.fromJson(e)).toList();
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
