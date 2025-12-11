import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative icons and illustration
            SizedBox(
              height: 280.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main illustration
                  Positioned(
                    child: Image.asset(
                      AppImages.lumiRobot,
                      height: 180.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Chart icon (top-left)
                  Positioned(
                    top: 20.h,
                    left: 20.w,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.paleSalmon,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        color: AppColors.vividOrange,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  // Trophy icon (top-right)
                  Positioned(
                    top: 40.h,
                    right: 30.w,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.paleSalmon,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: AppColors.vividOrange,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  // Calendar icon (bottom-left)
                  Positioned(
                    bottom: 30.h,
                    left: 30.w,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.paleSalmon,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: AppColors.vividOrange,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  // Wavy line decoration
                  Positioned(
                    top: 80.h,
                    right: 60.w,
                    child: CustomPaint(
                      size: Size(60.w, 30.h),
                      painter: WavyLinePainter(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Title
            Text(
              'Limited Knowledge',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBrown,
              ),
            ),
            SizedBox(height: 12.h),
            // Description
            Text(
              'No human being is perfect. So is chatbots. Dr Freud\'s knowledge is limited to 2023',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.darkSlateGray,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavyLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brightYellow
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i += 10) {
      path.lineTo(i, size.height / 2 + (i % 20 == 0 ? -5 : 5));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
