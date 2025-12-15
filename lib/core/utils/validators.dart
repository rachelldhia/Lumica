import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

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

  /// Validate password strength (enhanced)
  static ValidationResult validatePassword(String password) {
    if (password.isEmpty) {
      return const ValidationResult.error('Password cannot be empty');
    }

    if (password.length < 8) {
      return const ValidationResult.error(
        'Password must be at least 8 characters',
      );
    }

    // Check for at least one number or special character for stronger security
    final hasNumberOrSpecial = RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]');
    if (!hasNumberOrSpecial.hasMatch(password)) {
      return const ValidationResult.error(
        'Password must contain at least one number or special character',
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

  /// Validate display name (full name)
  static ValidationResult validateName(String name, {int maxLength = 50}) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return const ValidationResult.error('Name cannot be empty');
    }

    if (trimmed.length > maxLength) {
      return ValidationResult.error(
        'Name too long (max $maxLength characters)',
      );
    }

    // Only allow letters, spaces, hyphens, dots, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s\-\.']+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return const ValidationResult.error(
        'Name can only contain letters, spaces, hyphens, dots, and apostrophes',
      );
    }

    return const ValidationResult.success();
  }

  /// Validate image file
  static Future<ValidationResult> validateImage(File imageFile) async {
    const maxSizeBytes = 5 * 1024 * 1024; // 5MB
    const maxWidth = 2048;
    const maxHeight = 2048;

    try {
      // Check file size
      final bytes = await imageFile.length();
      if (bytes > maxSizeBytes) {
        return const ValidationResult.error('Image size must be less than 5MB');
      }

      // Check dimensions
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        return const ValidationResult.error('Invalid image file');
      }

      if (image.width > maxWidth || image.height > maxHeight) {
        return ValidationResult.error(
          'Image dimensions must be less than ${maxWidth}x${maxHeight}px',
        );
      }

      return const ValidationResult.success();
    } catch (e) {
      debugPrint('❌ Image validation error: $e');
      return const ValidationResult.error('Failed to validate image');
    }
  }
}

/// Sanitization utilities for user input
class InputSanitizer {
  /// Sanitize general text input (remove HTML tags and special chars)
  static String sanitizeText(String input) {
    return input
        .trim()
        // Remove script tags
        .replaceAll(
          RegExp(
            r'<script[^>]*>.*?</script>',
            caseSensitive: false,
            multiLine: true,
          ),
          '',
        )
        // Remove all HTML tags
        .replaceAll(RegExp(r'<[^>]*>'), '')
        // Remove potentially dangerous special characters
        .replaceAll(RegExp(r'''[<>&"']'''), '')
        .trim();
  }

  /// Sanitize for SQL-like inputs (basic protection)
  static String sanitizeQuery(String input) {
    return input
        .trim()
        // Remove common SQL injection patterns
        .replaceAll(RegExp(r'''[;'"\/\\]'''), '')
        .replaceAll('--', '')
        .replaceAll('/*', '')
        .replaceAll('*/', '')
        .trim();
  }

  /// Sanitize email (remove extra spaces and convert to lowercase)
  static String sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  /// Sanitize name (trim and proper case)
  static String sanitizeName(String name) {
    final trimmed = name.trim();
    // Remove multiple spaces
    return trimmed.replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Check for XSS patterns
  static bool containsXSS(String input) {
    final xssPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'onerror=', caseSensitive: false),
      RegExp(r'onload=', caseSensitive: false),
      RegExp(r'onclick=', caseSensitive: false),
      RegExp(r'<iframe', caseSensitive: false),
    ];

    for (final pattern in xssPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Validate and sanitize URL
  static String? sanitizeUrl(String url) {
    final trimmed = url.trim();

    // Only allow http and https protocols
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return null;
    }

    // Check for XSS in URL
    if (containsXSS(trimmed)) {
      return null;
    }

    return trimmed;
  }
}
