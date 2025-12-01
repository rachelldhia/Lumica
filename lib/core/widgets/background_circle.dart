import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';

enum CirclePosition { topCenter, centerLeft }

class BackgroundCircle extends StatelessWidget {
  const BackgroundCircle({super.key, required this.position, this.circleColor});

  final CirclePosition position;

  final Color? circleColor;

  @override
  Widget build(BuildContext context) {
    double? top;

    double? left;

    double? circleSize;

    switch (position) {
      case CirclePosition.topCenter:
        circleSize = 600.w;
        top = -circleSize / 1.3; // Positioned to clip at the top

        left = ScreenUtil().screenWidth / 2 - circleSize / 2;

        break;

      case CirclePosition.centerLeft:
        circleSize = 400.w;
        top = ScreenUtil().screenHeight / 2 - circleSize / 2;

        left = -130.w;

        break;
    }

    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: circleColor ?? AppColors.circlePurple.withAlpha(100),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
