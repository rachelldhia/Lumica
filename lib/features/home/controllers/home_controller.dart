import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';

class HomeController extends GetxController {
  // Selected mood index (0: Happy, 1: Calm, 2: Exited, 3: Angry, 4: Sad)
  var selectedMoodIndex = RxnInt();

  // User name
  var userName = ''.obs;

  // Time-based greeting
  var greeting = 'Good Morning,'.obs;

  // Current quote
  var currentQuote = ''.obs;

  // Navigation index for bottom nav bar
  var currentNavIndex = 0.obs;

  // Timer for auto-rotating quotes
  Timer? _quoteTimer;

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
    _loadUserData();
    _updateGreeting();
    _setRandomQuote();
    _startQuoteRotation();
  }

  @override
  void onClose() {
    _quoteTimer?.cancel();
    super.onClose();
  }

  // Load user data from Supabase
  void _loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      // Extract username from email (part before @) or use metadata name
      String username = user.userMetadata?['name'] as String? ?? '';

      if (username.isEmpty && user.email != null) {
        // Get part before @ from email
        username = user.email!.split('@').first;
        // Format username: replace dots/underscores with spaces and capitalize
        username = _formatUsername(username);
      }

      userName.value = username.isNotEmpty ? username : 'Friend';
    } else {
      userName.value = 'Friend';
    }
  }

  // Format username: replace separators with spaces and capitalize
  String _formatUsername(String username) {
    // Replace common separators with spaces
    String formatted = username
        .replaceAll('.', ' ')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');

    // Capitalize first letter of each word
    return formatted
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
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
    _quoteTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _setRandomQuote();
    });
  }

  void selectMood(int index) {
    if (selectedMoodIndex.value == index) {
      selectedMoodIndex.value = null; // Deselect if already selected
    } else {
      selectedMoodIndex.value = index;
    }
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
    // Delegate to DashboardController for actual navigation
    final dashboardController = Get.find<DashboardController>();
    dashboardController.changeTabIndex(index);
  }
}
