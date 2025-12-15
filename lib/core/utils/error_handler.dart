import 'package:flutter/foundation.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';

/// Centralized error handling utility
/// Provides consistent error handling and user-friendly messages across the app
class ErrorHandler {
  /// Handle errors globally with user-friendly messages
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   await repository.getData();
  /// } catch (e, stack) {
  ///   ErrorHandler.handle(e, stack, context: 'HomeController.loadData');
  /// }
  /// ```
  static void handle(
    Object error,
    StackTrace stack, {
    String? context,
    bool showSnackbar = true,
  }) {
    // Log error with context
    final contextInfo = context != null ? ' in $context' : '';
    debugPrint('❌ Error$contextInfo: $error');

    if (kDebugMode) {
      debugPrintStack(stackTrace: stack, maxFrames: 10);
    }

    // Get user-friendly message
    final message = _getUserMessage(error);

    // Show user feedback if enabled
    if (showSnackbar) {
      AppSnackbar.error(message, title: 'Error');
    }

    // TODO: Send to error tracking service (Firebase Crashlytics, Sentry, etc)
    // if (kReleaseMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, reason: context);
    // }
  }

  /// Handle failures from repositories (Either pattern)
  static void handleFailure(
    Failure failure, {
    String? context,
    bool showSnackbar = true,
  }) {
    final contextInfo = context != null ? ' in $context' : '';
    debugPrint('❌ Failure$contextInfo: ${failure.message}');

    if (showSnackbar) {
      AppSnackbar.error(failure.message, title: 'Error');
    }
  }

  /// Convert error to user-friendly message
  static String _getUserMessage(Object error) {
    // Handle known error types
    if (error is Failure) {
      return error.message;
    }

    final errorStr = error.toString().toLowerCase();

    // Network errors
    if (errorStr.contains('socket') ||
        errorStr.contains('network') ||
        errorStr.contains('connection')) {
      return 'Connection issue. Please check your internet connection.';
    }

    // Timeout errors
    if (errorStr.contains('timeout')) {
      return 'Request timeout. Please try again.';
    }

    // Authentication errors
    if (errorStr.contains('auth') ||
        errorStr.contains('unauthorized') ||
        errorStr.contains('401')) {
      return 'Authentication error. Please sign in again.';
    }

    // Permission errors
    if (errorStr.contains('permission') ||
        errorStr.contains('forbidden') ||
        errorStr.contains('403')) {
      return 'You don\'t have permission to perform this action.';
    }

    // Not found errors
    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'The requested resource was not found.';
    }

    // Server errors
    if (errorStr.contains('server') ||
        errorStr.contains('500') ||
        errorStr.contains('503')) {
      return 'Server error. Please try again later.';
    }

    // API quota
    if (errorStr.contains('quota') || errorStr.contains('rate limit')) {
      return 'Service temporarily unavailable. Please try again in a moment.';
    }

    // Generic fallback
    return 'Something went wrong. Please try again.';
  }

  /// Log warning (non-critical)
  static void warning(String message, {String? context}) {
    final contextInfo = context != null ? ' in $context' : '';
    debugPrint('⚠️ Warning$contextInfo: $message');
  }

  /// Log info
  static void info(String message, {String? context}) {
    final contextInfo = context != null ? ' in $context' : '';
    debugPrint('ℹ️ Info$contextInfo: $message');
  }

  /// Log success
  static void success(String message, {String? context}) {
    final contextInfo = context != null ? ' in $context' : '';
    debugPrint('✅ Success$contextInfo: $message');
  }
}
