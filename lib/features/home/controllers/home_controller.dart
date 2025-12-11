import 'package:get/get.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';

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
