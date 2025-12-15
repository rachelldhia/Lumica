import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

/// Standardized AppBar component for consistent UI across the app
///
/// Features:
/// - Consistent styling (background, elevation, text theme)
/// - Automatic back button with custom callback support
/// - Flexible action buttons
/// - Optional title widget or string
/// - Transparent or custom background
///
/// Example:
/// ```dart
/// BaseAppBar(
///   title: 'My Page',
///   actions: [
///     IconButton(icon: Icon(Icons.search), onPressed: () {}),
///   ],
/// )
/// ```
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final bool transparent;

  const BaseAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.centerTitle = false,
    this.elevation = 0,
    this.transparent = false,
  }) : assert(
         title == null || titleWidget == null,
         'Cannot provide both title and titleWidget',
       );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: transparent
          ? Colors.transparent
          : (backgroundColor ?? AppColors.whiteColor),
      elevation: elevation,
      centerTitle: centerTitle,
      leading: _buildLeading(),
      title: _buildTitle(),
      actions: actions,
      // Ensure consistent icon theme
      iconTheme: IconThemeData(color: AppColors.darkBrown, size: 24.w),
    );
  }

  Widget? _buildLeading() {
    if (leading != null) return leading;

    if (showBackButton && Get.previousRoute.isNotEmpty) {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, size: 20.w),
        onPressed: onBackPressed ?? () => Get.back(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  Widget? _buildTitle() {
    if (titleWidget != null) return titleWidget;

    if (title != null) {
      return Text(
        title!,
        style: AppTextTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.darkBrown,
          fontSize: 20.sp,
        ),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

/// Transparent AppBar variant for overlaying on content
class TransparentAppBar extends BaseAppBar {
  const TransparentAppBar({
    super.key,
    super.title,
    super.titleWidget,
    super.actions,
    super.leading,
    super.showBackButton = true,
    super.onBackPressed,
  }) : super(transparent: true, elevation: 0);
}

/// AppBar with search field
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;
  final TextEditingController? controller;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onClose,
    this.controller,
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          size: 20.w,
          color: AppColors.darkBrown,
        ),
        onPressed: onClose,
      ),
      title: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        style: AppTextTheme.textTheme.bodyLarge?.copyWith(
          color: AppColors.darkBrown,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
            color: AppColors.darkBrown.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
      actions: [
        if (controller != null && controller!.text.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear, color: AppColors.darkBrown),
            onPressed: () {
              controller!.clear();
              onChanged('');
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
