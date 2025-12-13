import 'package:lumica_app/domain/entities/mood_entry.dart';

abstract class MoodRepository {
  /// Get all mood entries for a specific user
  Future<List<MoodEntry>> getMoodEntries(String userId);

  /// Save a new mood entry
  Future<void> saveMoodEntry(MoodEntry entry);

  /// Get mood statistics (percentage for each mood type)
  /// Returns a map with mood names as keys and percentages as values
  Future<Map<String, double>> getMoodStatistics(String userId);
}
