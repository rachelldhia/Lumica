import 'package:flutter/material.dart';
// import 'package:lumica_app/core/config/theme.dart'; // Unused
// import 'package:lumica_app/core/config/app_text_theme.dart'; // Merged in theme.dart
import 'package:get/get.dart';

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorWidget({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: Colors.red, // AppColors.error
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: context.textTheme.headlineMedium, // AppTextTheme.h2
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We apologize for the inconvenience. Our team has been notified.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600], // AppColors.textSecondary
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Restart App
                  Get.offAllNamed('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor, // AppColors.primary
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Restart App',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Hidden error details for developers (or show in debug mode)
              if (Get.context?.theme.platform == TargetPlatform.android ||
                  Get.context?.theme.platform == TargetPlatform.iOS) ...[
                // Do not show stack trace in production UI
              ] else ...[
                // Web/Desktop might want to see it
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      errorDetails.exceptionAsString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
