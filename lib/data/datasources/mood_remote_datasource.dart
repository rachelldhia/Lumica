import 'package:flutter/foundation.dart';
import 'package:lumica_app/core/errors/exceptions.dart';
import 'package:lumica_app/domain/entities/mood_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodRemoteDataSource {
  final SupabaseClient _supabase;

  MoodRemoteDataSource(this._supabase);

  Future<List<MoodEntry>> getMoodEntries(String userId) async {
    try {
      debugPrint('🔍 Fetching mood entries for user: $userId');

      final response = await _supabase
          .from('mood_entries')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false);

      debugPrint('✅ Mood entries fetched: ${(response as List).length} items');

      return (response as List)
          .map((json) => MoodEntry.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      debugPrint('❌ PostgrestException in getMoodEntries: ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      debugPrint('❌ Unexpected error in getMoodEntries: $e');
      throw ServerException(e.toString());
    }
  }

  Future<void> saveMoodEntry(MoodEntry entry) async {
    try {
      debugPrint('💾 Saving mood entry: ${entry.mood}');

      await _supabase.from('mood_entries').insert({
        'user_id': entry.userId,
        'mood': entry.mood,
        'timestamp': entry.timestamp.toIso8601String(),
        'notes': entry.notes,
      });

      debugPrint('✅ Mood entry saved successfully');
    } on PostgrestException catch (e) {
      debugPrint('❌ PostgrestException in saveMoodEntry: ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      debugPrint('❌ Unexpected error in saveMoodEntry: $e');
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, double>> getMoodStatistics(String userId) async {
    try {
      debugPrint('📊 Calculating mood statistics for user: $userId');

      final entries = await getMoodEntries(userId);

      if (entries.isEmpty) {
        debugPrint('⚠️ No mood entries found, returning default statistics');
        return {
          'happy': 0.0,
          'calm': 0.0,
          'excited': 0.0,
          'angry': 0.0,
          'sad': 0.0,
          'stress': 0.0,
        };
      }

      // Count occurrences of each mood
      final moodCounts = <String, int>{};
      for (final entry in entries) {
        moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
      }

      // Calculate percentages
      final total = entries.length;
      final statistics = <String, double>{};

      for (final mood in [
        'happy',
        'calm',
        'excited',
        'angry',
        'sad',
        'stress',
      ]) {
        final count = moodCounts[mood] ?? 0;
        statistics[mood] = (count / total) * 100;
      }

      debugPrint('✅ Mood statistics calculated: $statistics');
      return statistics;
    } catch (e) {
      debugPrint('❌ Error calculating mood statistics: $e');
      throw ServerException(e.toString());
    }
  }
}
