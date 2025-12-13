import 'package:flutter/foundation.dart';

/// Validation result for input data
class ValidationResult {
  final bool isValid;
  final String? message;

  const ValidationResult.success() : isValid = true, message = null;

  const ValidationResult.error(this.message) : isValid = false;

  @override
  String toString() => isValid ? 'Valid' : 'Invalid: $message';
}

/// Validator for Note input data
class NoteValidator {
  // Maximum lengths
  static const int maxTitleLength = 100;
  static const int maxContentLength = 50000; // ~50KB for rich text JSON

  /// Validate note title
  static ValidationResult validateTitle(String title) {
    if (title.trim().isEmpty) {
      return const ValidationResult.error('Title cannot be empty');
    }

    if (title.length > maxTitleLength) {
      return ValidationResult.error(
        'Title too long (max $maxTitleLength characters)',
      );
    }

    return const ValidationResult.success();
  }

  /// Validate note content (JSON string from Quill)
  static ValidationResult validateContent(String content) {
    if (content.isEmpty) {
      return const ValidationResult.error('Content cannot be empty');
    }

    if (content.length > maxContentLength) {
      return ValidationResult.error(
        'Content too long (max ${(maxContentLength / 1000).toStringAsFixed(0)}KB)',
      );
    }

    // Check if it's valid JSON (basic check)
    try {
      if (!content.startsWith('[') && !content.startsWith('{')) {
        return const ValidationResult.error('Invalid content format');
      }
    } catch (e) {
      debugPrint('⚠️ Content validation warning: $e');
    }

    return const ValidationResult.success();
  }

  /// Validate complete note
  static ValidationResult validateNote({
    required String title,
    required String content,
  }) {
    // Validate title
    final titleResult = validateTitle(title);
    if (!titleResult.isValid) return titleResult;

    // Validate content
    final contentResult = validateContent(content);
    if (!contentResult.isValid) return contentResult;

    return const ValidationResult.success();
  }
}

/// Validator for user input in general
class InputValidator {
  /// Validate email format
  static ValidationResult validateEmail(String email) {
    if (email.trim().isEmpty) {
      return const ValidationResult.error('Email cannot be empty');
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return const ValidationResult.error('Invalid email format');
    }

    return const ValidationResult.success();
  }

  /// Validate password strength
  static ValidationResult validatePassword(String password) {
    if (password.isEmpty) {
      return const ValidationResult.error('Password cannot be empty');
    }

    if (password.length < 6) {
      return const ValidationResult.error(
        'Password must be at least 6 characters',
      );
    }

    return const ValidationResult.success();
  }

  /// Validate username
  static ValidationResult validateUsername(String username) {
    if (username.trim().isEmpty) {
      return const ValidationResult.error('Username cannot be empty');
    }

    if (username.length < 3) {
      return const ValidationResult.error(
        'Username must be at least 3 characters',
      );
    }

    if (username.length > 30) {
      return const ValidationResult.error(
        'Username too long (max 30 characters)',
      );
    }

    return const ValidationResult.success();
  }
}
