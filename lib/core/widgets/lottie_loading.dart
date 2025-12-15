import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// Animated loading widget using Lottie
class LottieLoading extends StatelessWidget {
  final double size;
  final String? message;

  const LottieLoading({super.key, this.size = 120, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.network(
          // Calm meditation animation - mental wellness themed
          'https://lottie.host/c4e9d2c1-7cbd-4f2e-8b8d-d0cc3f8d8bd0/0Hq1TlhXoQ.json',
          width: size.w,
          height: size.w,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to circular indicator
            return SizedBox(
              width: size.w,
              height: size.w,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
        if (message != null) ...[
          SizedBox(height: 16.h),
          Text(
            message!,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }
}

/// Simple pulsing dots loading indicator
class PulsingDotsLoader extends StatefulWidget {
  final Color color;
  final double dotSize;

  const PulsingDotsLoader({
    super.key,
    this.color = Colors.orange,
    this.dotSize = 10,
  });

  @override
  State<PulsingDotsLoader> createState() => _PulsingDotsLoaderState();
}

class _PulsingDotsLoaderState extends State<PulsingDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + (0.5 * (1 - (value - 0.5).abs() * 2));

            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: widget.dotSize.w,
            height: widget.dotSize.w,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
