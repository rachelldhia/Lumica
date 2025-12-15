import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Request a permission with a dialog if needed
  /// Returns true if granted
  static Future<bool> requestPermission(
    Permission permission, {
    String? title,
    String? message,
  }) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await _showSettingsDialog(
        title ?? 'Permission Required',
        message ??
            'This feature requires permission to access your device settings. Please enable it in settings.',
      );
      return false;
    }

    // Request permission
    final result = await permission.request();
    if (result.isGranted) {
      return true;
    } else if (result.isPermanentlyDenied) {
      await _showSettingsDialog(
        title ?? 'Permission Required',
        message ??
            'This feature requires permission. Please enable it in system settings.',
      );
    }

    return false;
  }

  static Future<void> _showSettingsDialog(String title, String message) async {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
