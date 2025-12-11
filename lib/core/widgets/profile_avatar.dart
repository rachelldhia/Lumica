import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.imagePath,
    this.borderWidth = 2.5,
  });

  final double size;
  final String? imagePath;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    // Check if imagePath is a network URL
    final isNetworkImage = imagePath?.startsWith('http') ?? false;

    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.vividOrange, width: borderWidth),
      ),
      child: ClipOval(
        child: isNetworkImage
            ? CachedNetworkImage(
                imageUrl: imagePath!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.stoneGray,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.stoneGray.withValues(alpha: 0.3),
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: AppColors.darkBrown.withValues(alpha: 0.5),
                  ),
                ),
              )
            : (imagePath != null && imagePath!.isNotEmpty)
            ? Image.asset(imagePath!, fit: BoxFit.cover)
            : Container(
                color: AppColors.stoneGray.withValues(alpha: 0.3),
                child: Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: AppColors.darkBrown.withValues(alpha: 0.5),
                ),
              ),
      ),
    );
  }
}
