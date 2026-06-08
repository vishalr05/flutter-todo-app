import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

/// ──────────────────────────────────────────────
/// Helper utilities for TaskFlow
/// ──────────────────────────────────────────────

// ── Date Formatting ────────────────────────────

/// Formats a DateTime into a user-friendly string.
/// Examples: "Today", "Tomorrow", "Yesterday", "Jun 15, 2026"
String formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly = DateTime(date.year, date.month, date.day);
  final diff = dateOnly.difference(today).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff == -1) return 'Yesterday';

  return DateFormat('MMM d, yyyy').format(date);
}

/// Formats a DateTime into a short date string (e.g., "Jun 15").
String formatDateShort(DateTime date) {
  return DateFormat('MMM d').format(date);
}

// ── Greeting ───────────────────────────────────

/// Returns a time-appropriate greeting message.
/// "Good Morning" (5-11), "Good Afternoon" (12-16), "Good Evening" (17+)
String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

// ── Priority Helpers ───────────────────────────

/// Returns the color associated with a priority level.
Color getPriorityColor(int priority) {
  switch (priority) {
    case 2:
      return AppColors.priorityHigh;
    case 1:
      return AppColors.priorityMedium;
    default:
      return AppColors.priorityLow;
  }
}

/// Returns the label for a priority level.
String getPriorityLabel(int priority) {
  switch (priority) {
    case 2:
      return 'High';
    case 1:
      return 'Medium';
    default:
      return 'Low';
  }
}

/// Returns an icon for a priority level.
IconData getPriorityIcon(int priority) {
  switch (priority) {
    case 2:
      return Icons.flag_rounded;
    case 1:
      return Icons.flag_outlined;
    default:
      return Icons.outlined_flag_rounded;
  }
}

// ── ID Generation ──────────────────────────────

/// Generates a unique ID using timestamp + random suffix.
String generateId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = Random().nextInt(9999);
  return '${timestamp}_$random';
}

// ── Daily Quote ────────────────────────────────

/// Returns a motivational quote based on the current day.
/// The same quote is shown for the entire day.
String getDailyQuote() {
  final dayOfYear = DateTime.now().difference(
    DateTime(DateTime.now().year, 1, 1),
  ).inDays;
  final index = dayOfYear % AppQuotes.quotes.length;
  return AppQuotes.quotes[index];
}

// ── Due Date Status ────────────────────────────

/// Returns true if the task is overdue (past due date and not completed).
bool isOverdue(DateTime dueDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
  return dateOnly.isBefore(today);
}

/// Returns a color for the due date text based on urgency.
Color getDueDateColor(DateTime dueDate, bool isCompleted) {
  if (isCompleted) return AppColors.textLight;
  if (isOverdue(dueDate)) return AppColors.priorityHigh;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
  final diff = dateOnly.difference(today).inDays;

  if (diff == 0) return AppColors.priorityMedium; // Due today
  if (diff == 1) return AppColors.coral; // Due tomorrow
  return AppColors.textSecondary; // Future
}
