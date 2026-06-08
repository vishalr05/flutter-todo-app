import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

/// ──────────────────────────────────────────────
/// Stats Card Widget
/// ──────────────────────────────────────────────
///
/// A dashboard-style card showing task statistics:
///   - Circular progress indicator with percentage
///   - Total, completed, and pending task counts
///   - Gradient background
class StatsCard extends StatelessWidget {
  final int total;
  final int completed;
  final int pending;
  final double completionPercentage;

  const StatsCard({
    super.key,
    required this.total,
    required this.completed,
    required this.pending,
    required this.completionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.lavender.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Progress Circle ──
          _buildProgressCircle(),
          const SizedBox(width: 20),

          // ── Stats Text ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatItem('Total', total, Colors.white),
                    const SizedBox(width: 16),
                    _buildStatItem('Done', completed, const Color(0xFF86EFAC)),
                    const SizedBox(width: 16),
                    _buildStatItem('To Do', pending, const Color(0xFFFDE68A)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .slideY(
          begin: 0.1,
          end: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
  }

  /// Circular progress indicator with percentage text
  Widget _buildProgressCircle() {
    final percentage = (completionPercentage * 100).round();
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white24,
              ),
            ),
          ),
          // Progress arc
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: completionPercentage,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          // Percentage text
          Text(
            '$percentage%',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// A single stat item (label + count)
  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$count',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
