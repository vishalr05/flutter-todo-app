import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// ──────────────────────────────────────────────
/// Priority Selector Widget
/// ──────────────────────────────────────────────
///
/// A row of three selectable chips for choosing
/// task priority: Low (green), Medium (yellow), High (red).
/// Used in the Add/Edit task screens.
class PrioritySelector extends StatelessWidget {
  final int selectedPriority;
  final ValueChanged<int> onChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _buildChip(context, 0, isDark), // Low
        const SizedBox(width: 10),
        _buildChip(context, 1, isDark), // Medium
        const SizedBox(width: 10),
        _buildChip(context, 2, isDark), // High
      ],
    );
  }

  Widget _buildChip(BuildContext context, int priority, bool isDark) {
    final isSelected = selectedPriority == priority;
    final color = getPriorityColor(priority);
    final label = getPriorityLabel(priority);
    final icon = getPriorityIcon(priority);

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(priority),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : (isDark ? AppColors.cardDark : Colors.white),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            border: Border.all(
              color: isSelected ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? color : (isDark ? Colors.grey.shade500 : AppColors.textLight)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : (isDark ? Colors.grey.shade400 : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
