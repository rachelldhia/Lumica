import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Base controller with common patterns for loading, error handling, and state management
/// All feature controllers should extend this for consistency
abstract class BaseController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;

  // Error state
  final Rx<String?> errorMessage = Rx(null);

  // Success message (optional)
  final Rx<String?> successMessage = Rx(null);

  /// Execute an async operation with automatic loading and error handling
  /// Returns the result or null if an error occurred
  Future<T?> executeWithLoading<T>(
    Future<T> Function() operation, {
    String? errorContext,
    String? successMsg,
    bool showError = true,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      successMessage.value = null;

      final result = await operation();

      if (successMsg != null) {
        successMessage.value = successMsg;
      }

      return result;
    } catch (e) {
      if (showError) {
        errorMessage.value = e.toString();
      }

      // Log error
      debugPrint(
        '❌ Error${errorContext != null ? " in $errorContext" : ""}: $e',
      );

      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all state messages
  void clearMessages() {
    errorMessage.value = null;
    successMessage.value = null;
  }

  /// Reset controller state
  void resetState() {
    isLoading.value = false;
    clearMessages();
  }
}
