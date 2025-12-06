import 'dart:async';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Selected mood index (0: Happy, 1: Calm, 2: Exited, 3: Angry, 4: Sad)
  var selectedMoodIndex = RxnInt();

  // User name (can be fetched from auth/storage later)
  var userName = 'Mbud!'.obs;

  // Time-based greeting
  var greeting = 'Good Morning,'.obs;

  // Current quote
  var currentQuote = ''.obs;

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
    _updateGreeting();
    _setRandomQuote();
    _startQuoteRotation();
  }

  @override
  void onClose() {
    _quoteTimer?.cancel();
    super.onClose();
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
    // Auto-rotate quotes every 10 seconds
    _quoteTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
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
}
