import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumica_app/core/config/theme.dart';

/// Standardized pull-to-refresh wrapper with app branding
class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await onRefresh();
      },
      color: color ?? AppColors.vividOrange,
      backgroundColor: backgroundColor ?? AppColors.whiteColor,
      strokeWidth: 2.5,
      displacement: 40,
      child: child,
    );
  }
}

/// Animated empty state widget
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;
  final Color? iconColor;

  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.action,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.paleSalmon.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor ?? AppColors.vividOrange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 14, color: AppColors.darkSlateGray),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

/// Animated error state widget
class AppErrorState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.brightRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.brightRed,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 14, color: AppColors.darkSlateGray),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.vividOrange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
