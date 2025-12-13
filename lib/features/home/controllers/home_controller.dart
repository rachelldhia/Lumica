import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/domain/entities/mood_entry.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  // Dependencies
  late final ProfileController _profileController;

  // Selected mood index (0: Happy, 1: Calm, 2: Exited, 3: Angry, 4: Sad)
  var selectedMoodIndex = RxnInt();

  // User name (Get from ProfileController)
  RxString get userName => _profileController.userName;
  RxString get userAvatarUrl => _profileController.userAvatarUrl;

  // Time-based greeting
  var greeting = 'Good Morning,'.obs;

  // Current quote
  var currentQuote = ''.obs;

  // Navigation index for bottom nav bar
  var currentNavIndex = 0.obs;

  // List of inspirational quotes
  final List<String> quotes = [
    '"It is better to conquer yourself than to win a thousand battles"',
    '"The mind is everything. What you think you become"',
    '"Peace comes from within. Do not seek it without"',
    '"You yourself, as much as anybody, deserve your love and affection"',
    '"The only way out is through"',
    '"Healing takes time, and asking for help is a courageous step"',
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize ProfileController
    _profileController = Get.find<ProfileController>();

    _updateGreeting();
    _setRandomQuote();
    _startQuoteRotation();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning,';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon,';
    } else {
      greeting.value = 'Good Evening,';
    }
  }

  void _setRandomQuote() {
    quotes.shuffle();
    currentQuote.value = quotes.first;
  }

  void _startQuoteRotation() {
    // Auto-rotate quotes every 5 minutes
    _quoteTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _setRandomQuote();
    });
  }

  // Timer for quote rotation
  Timer? _quoteTimer;

  @override
  void onClose() {
    _quoteTimer?.cancel();
    super.onClose();
  }

  void selectMood(int index) async {
    if (selectedMoodIndex.value == index) {
      selectedMoodIndex.value = null; // Deselect if already selected
    } else {
      selectedMoodIndex.value = index;

      // Save mood to database with proper error handling
      final success = await _saveMoodEntry(index);
      if (!success) {
        AppSnackbar.warning(
          'Mood selected but not saved. Please try again.',
          title: 'Warning',
        );
      }
    }
  }

  /// Save mood entry to database with proper error handling
  /// Returns true if successful, false otherwise
  Future<bool> _saveMoodEntry(int index) async {
    final moodNames = ['happy', 'calm', 'excited', 'angry', 'sad', 'stress'];

    // Validate index
    if (index < 0 || index >= moodNames.length) {
      debugPrint('❌ Invalid mood index: $index');
      return false;
    }

    try {
      // Check authentication
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ User not authenticated');
        return false;
      }

      // Check if MoodRepository is available
      if (!Get.isRegistered<MoodRepository>()) {
        debugPrint('⚠️ MoodRepository not available yet');
        return false;
      }

      // Get repository and save
      final moodRepository = Get.find<MoodRepository>();
      final entry = MoodEntry(
        id: const Uuid().v4(),
        userId: userId,
        mood: moodNames[index],
        timestamp: DateTime.now(),
      );

      await moodRepository.saveMoodEntry(entry);
      debugPrint('✅ Mood saved successfully: ${moodNames[index]}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to save mood: $e');
      return false;
    }
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
    // Delegate to DashboardController for actual navigation
    final dashboardController = Get.find<DashboardController>();
    dashboardController.changeTabIndex(index);
  }
}
