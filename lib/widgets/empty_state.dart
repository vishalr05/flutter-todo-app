import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

/// ──────────────────────────────────────────────
/// Empty State Widget
/// ──────────────────────────────────────────────
///
/// Displayed when the task list is empty.
/// Shows a visual illustration built with Flutter widgets
/// (no external images needed) and a motivational message.
class EmptyState extends StatelessWidget {
  final String message;
  final String subtitle;

  const EmptyState({
    super.key,
    this.message = 'No tasks yet!',
    this.subtitle = 'Tap the + button to add your first task',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Illustration ──
            _buildIllustration(isDark),
            const SizedBox(height: 32),

            // ── Message ──
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // ── Subtitle ──
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.grey.shade500 : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
  }

  /// Build the illustration using Flutter widgets
  Widget _buildIllustration(bool isDark) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.lavender.withValues(alpha: 0.1),
                  AppColors.coral.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Inner circle
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.lavender.withValues(alpha: 0.15),
                  AppColors.coral.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Clipboard icon
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: isDark
                ? AppColors.lavender.withValues(alpha: 0.6)
                : AppColors.lavender.withValues(alpha: 0.5),
          ),

          // Floating checkmark (top-right)
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.priorityLow.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 18,
                color: AppColors.priorityLow,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(
                  begin: 0,
                  end: -8,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                ),
          ),

          // Floating star (bottom-left)
          Positioned(
            bottom: 35,
            left: 25,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                size: 16,
                color: AppColors.coral,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(
                  begin: 0,
                  end: 6,
                  duration: const Duration(milliseconds: 2500),
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    );
  }
}
