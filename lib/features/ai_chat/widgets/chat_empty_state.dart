import 'dart:math';
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
                  // Main illustration with subtle pulse
                  Positioned(
                    child: _PulsingImage(
                      imagePath: AppImages.lumiRobot,
                      height: 180.h,
                    ),
                  ),
                  // Chart icon (top-left) - floating
                  Positioned(
                    top: 20.h,
                    left: 20.w,
                    child: _FloatingIcon(
                      icon: Icons.bar_chart_rounded,
                      delay: 0,
                    ),
                  ),
                  // Trophy icon (top-right) - floating
                  Positioned(
                    top: 40.h,
                    right: 30.w,
                    child: _FloatingIcon(icon: Icons.emoji_events, delay: 1),
                  ),
                  // Calendar icon (bottom-left) - floating
                  Positioned(
                    bottom: 30.h,
                    left: 30.w,
                    child: _FloatingIcon(icon: Icons.calendar_today, delay: 2),
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

/// Floating icon with gentle up-down animation
class _FloatingIcon extends StatefulWidget {
  final IconData icon;
  final int delay;

  const _FloatingIcon({required this.icon, required this.delay});

  @override
  State<_FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<_FloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500 + (widget.delay * 300)),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -6.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.rotate(angle: _rotateAnimation.value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.paleSalmon,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.vividOrange.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(widget.icon, color: AppColors.vividOrange, size: 24.sp),
      ),
    );
  }
}

/// Pulsing image animation for the main illustration
class _PulsingImage extends StatefulWidget {
  final String imagePath;
  final double height;

  const _PulsingImage({required this.imagePath, required this.height});

  @override
  State<_PulsingImage> createState() => _PulsingImageState();
}

class _PulsingImageState extends State<_PulsingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Image.asset(
        widget.imagePath,
        height: widget.height,
        fit: BoxFit.contain,
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
      path.lineTo(i, size.height / 2 + (sin(i / 10 * pi) * 5));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
