import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/domain/entities/mood_entry.dart';

/// Mood Chart Widget for Home Page
/// Displays weekly mood statistics using fl_chart
class MoodChartCard extends StatelessWidget {
  final List<MoodEntry> moodEntries;
  final bool isLoading;

  const MoodChartCard({
    super.key,
    required this.moodEntries,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (moodEntries.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.vividOrange.withValues(alpha: 0.1),
            AppColors.skyBlue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.vividOrange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood This Week',
                style: AppTextTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBrown,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.vividOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Last 7 days',
                  style: AppTextTheme.textTheme.bodySmall?.copyWith(
                    color: AppColors.vividOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Chart
          SizedBox(height: 140.h, child: _buildChart()),

          SizedBox(height: 12.h),

          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final weekData = _getWeekData();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final day = weekData[groupIndex]['day'] as String;
              final mood = rod.toY.round();
              if (mood == 0) return null; // No tooltip for empty data

              return BarTooltipItem(
                '$day\n${_getMoodLabel(mood)}',
                AppTextTheme.textTheme.bodySmall!.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < weekData.length) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      weekData[value.toInt()]['day'] as String,
                      style: AppTextTheme.textTheme.bodySmall?.copyWith(
                        color: AppColors.darkBrown.withValues(alpha: 0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28.w,
              getTitlesWidget: (value, meta) {
                if (value % 1 == 0 && value >= 1 && value <= 5) {
                  final moodImage = _getMoodImage(value.toInt());
                  if (moodImage != null) {
                    return Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Image.asset(moodImage, width: 20.w, height: 20.h),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.stoneGray.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: weekData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final mood = data['mood'] as double;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: mood,
                color: _getMoodColor(mood.toInt()),
                width: 20.w,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  topRight: Radius.circular(4.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    _getMoodColor(mood.toInt()).withValues(alpha: 0.7),
                    _getMoodColor(mood.toInt()),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getWeekData() {
    final now = DateTime.now();
    final weekData = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = DateFormat('EEE').format(date);

      // Find mood for this day
      final dayMoods = moodEntries.where((entry) {
        return entry.timestamp.year == date.year &&
            entry.timestamp.month == date.month &&
            entry.timestamp.day == date.day;
      }).toList();

      // Calculate average mood or 0 if no data
      double avgMood = 0;
      if (dayMoods.isNotEmpty) {
        avgMood =
            dayMoods
                .map((e) => _moodStringToLevel(e.mood))
                .reduce((a, b) => a + b) /
            dayMoods.length;
      }

      weekData.add({
        'day': dayName,
        'mood': avgMood,
        'hasData': dayMoods.isNotEmpty,
      });
    }

    return weekData;
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(AppImages.emoHappy, 'Happy', const Color(0xFF4CAF50)),
        _buildLegendItem(AppImages.emoCalm, 'Calm', AppColors.skyBlue),
        _buildLegendItem(AppImages.emoAngry, 'Angry', AppColors.amethyst),
        _buildLegendItem(AppImages.emoSad, 'Sad', AppColors.vividOrange),
      ],
    );
  }

  Widget _buildLegendItem(String imagePath, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 18.w, height: 18.h),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextTheme.textTheme.bodySmall?.copyWith(
            color: AppColors.darkBrown.withValues(alpha: 0.7),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.stoneGray.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.vividOrange),
            SizedBox(height: 12.h),
            Text(
              'Loading mood data...',
              style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                color: AppColors.darkBrown.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.amethyst.withValues(alpha: 0.1),
            AppColors.skyBlue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.insert_chart_outlined_rounded,
            size: 48.sp,
            color: AppColors.amethyst.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            'No Mood Data Yet',
            style: AppTextTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkBrown,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Start tracking your mood to see patterns',
            textAlign: TextAlign.center,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.darkBrown.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 5:
        return 'Great';
      case 4:
        return 'Good';
      case 3:
        return 'Okay';
      case 2:
        return 'Bad';
      case 1:
        return 'Terrible';
      default:
        return 'No data';
    }
  }

  Color _getMoodColor(int mood) {
    switch (mood) {
      case 5:
        return const Color(0xFF4CAF50); // Green
      case 4:
        return AppColors.skyBlue;
      case 3:
        return AppColors.amethyst;
      case 2:
        return AppColors.vividOrange;
      case 1:
        return const Color(0xFFE57373); // Red
      default:
        return AppColors.stoneGray;
    }
  }

  /// Convert mood string to level (1-5)
  double _moodStringToLevel(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return 5.0;
      case 'calm':
        return 4.0;
      case 'excited':
        return 4.5;
      case 'angry':
        return 2.0;
      case 'sad':
        return 1.0;
      case 'stress':
        return 2.5;
      default:
        return 3.0;
    }
  }

  /// Get mood image asset path
  String? _getMoodImage(int mood) {
    switch (mood) {
      case 5:
        return AppImages.emoHappy;
      case 4:
        return AppImages.emoCalm;
      case 3:
        return AppImages.emoStress; // Neutral
      case 2:
        return AppImages.emoAngry;
      case 1:
        return AppImages.emoSad;
      default:
        return null;
    }
  }
}
