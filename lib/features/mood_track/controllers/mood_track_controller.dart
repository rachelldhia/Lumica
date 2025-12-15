import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/domain/entities/mood_entry.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MoodTrackController extends GetxController {
  final MoodRepository _moodRepository = Get.find<MoodRepository>();

  // Observable state
  final isLoading = true.obs;
  final moodStatistics = <String, double>{}.obs;
  final dominantMood = 'happy'.obs;

  // Animation key for forcing animation replay on navigation
  final RxInt animationKey = 0.obs;

  // Mood names mapping
  final moodNames = {
    'happy': 'Happy',
    'calm': 'Calm',
    'excited': 'Excited',
    'angry': 'Angry',
    'sad': 'Sad',
    'stress': 'Stress',
  };

  @override
  void onInit() {
    super.onInit();
    loadMoodStatistics();
  }

  Future<void> loadMoodStatistics() async {
    try {
      isLoading.value = true;
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        debugPrint('❌ User not authenticated');
        AppSnackbar.error('auth.unexpectedError'.tr, title: 'common.error'.tr);
        return;
      }

      final stats = await _moodRepository.getMoodStatistics(userId);
      moodStatistics.value = stats;

      // Determine dominant mood
      _calculateDominantMood();
    } catch (e) {
      debugPrint('❌ Error loading mood statistics: $e');
      AppSnackbar.error('moodTrack.loadFailed'.tr, title: 'common.error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateDominantMood() {
    if (moodStatistics.isEmpty) {
      dominantMood.value = 'happy';
      return;
    }

    // Find mood with highest percentage
    String maxMood = 'happy';
    double maxPercentage = 0.0;

    moodStatistics.forEach((mood, percentage) {
      if (percentage > maxPercentage) {
        maxPercentage = percentage;
        maxMood = mood;
      }
    });

    dominantMood.value = maxMood;
  }

  double getMoodPercentage(String mood) {
    return moodStatistics[mood] ?? 0.0;
  }

  Future<void> saveMoodSelection(String mood) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        debugPrint('❌ User not authenticated');
        AppSnackbar.error('auth.unexpectedError'.tr, title: 'common.error'.tr);
        return;
      }

      final entry = MoodEntry(
        id: const Uuid().v4(),
        userId: userId,
        mood: mood,
        timestamp: DateTime.now(),
      );

      await _moodRepository.saveMoodEntry(entry);
      debugPrint('✅ Mood saved: $mood');

      // Reload statistics after saving
      await loadMoodStatistics();

      AppSnackbar.success('moodTrack.moodSaved'.tr);
    } catch (e) {
      debugPrint('❌ Error saving mood: $e');
      AppSnackbar.error('moodTrack.saveFailed'.tr, title: 'common.error'.tr);
    }
  }
}
