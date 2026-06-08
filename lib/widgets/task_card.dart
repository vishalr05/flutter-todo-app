import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// ──────────────────────────────────────────────
/// Task Card Widget
/// ──────────────────────────────────────────────
///
/// A modern card displaying a single task with:
///   - Animated checkbox for completion toggle
///   - Title (with strikethrough when completed)
///   - Description preview
///   - Due date and priority indicator
///   - Swipe-to-delete via Dismissible wrapper
///   - Tap to edit
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final int animationIndex;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onTap,
    required this.onDelete,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: _buildDismissBackground(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : AppColors.lavender)
                    .withValues(alpha: isDark ? 0.2 : 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Checkbox ──
                _buildCheckbox(context),
                const SizedBox(width: 12),

                // ── Content ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? (isDark ? Colors.grey.shade600 : AppColors.textLight)
                              : (isDark ? AppColors.textDark : AppColors.textPrimary),
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: AppColors.textLight,
                        ),
                      ),

                      // Description (if present)
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: task.isCompleted
                                ? (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
                                : (isDark ? Colors.grey.shade400 : AppColors.textSecondary),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: Colors.grey.shade400,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Due date + Priority row
                      Row(
                        children: [
                          // Due date chip
                          _buildDateChip(context),
                          const SizedBox(width: 8),
                          // Priority chip
                          _buildPriorityChip(),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Swipe hint icon ──
                Icon(
                  Icons.chevron_left_rounded,
                  color: (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: animationIndex * 80),
        )
        .slideX(
          begin: 0.05,
          end: 0,
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: animationIndex * 80),
          curve: Curves.easeOutCubic,
        );
  }

  /// Animated checkbox with color fill
  Widget _buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: onToggleComplete,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: 26,
        height: 26,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? AppColors.lavender
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: task.isCompleted
                ? AppColors.lavender
                : Colors.grey.shade400,
            width: 1.8,
          ),
        ),
        child: task.isCompleted
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : null,
      ),
    );
  }

  /// Date chip showing the due date with urgency-based color
  Widget _buildDateChip(BuildContext context) {
    final dateColor = getDueDateColor(task.dueDate, task.isCompleted);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: dateColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 12, color: dateColor),
          const SizedBox(width: 4),
          Text(
            formatDate(task.dueDate),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: dateColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Priority indicator chip
  Widget _buildPriorityChip() {
    final color = getPriorityColor(task.priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getPriorityIcon(task.priority), size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            getPriorityLabel(task.priority),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Red background shown when swiping to delete
  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.priorityHigh,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
