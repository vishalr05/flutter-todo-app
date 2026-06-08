import 'package:flutter/material.dart';

/// ──────────────────────────────────────────────
/// App-wide constants for TaskFlow
/// ──────────────────────────────────────────────

// ── Color Palette ──────────────────────────────
class AppColors {
  AppColors._(); // Prevent instantiation

  // Primary Colors
  static const Color lavender = Color(0xFF8B5CF6);
  static const Color coral = Color(0xFFFF7B72);

  // Background
  static const Color backgroundLight = Color(0xFFF8F9FD);
  static const Color backgroundDark = Color(0xFF1A1A2E);

  // Card Colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF252540);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textDark = Color(0xFFE5E7EB);

  // Priority Colors
  static const Color priorityLow = Color(0xFF34D399);
  static const Color priorityMedium = Color(0xFFFBBF24);
  static const Color priorityHigh = Color(0xFFEF4444);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lavender, coral],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFFEDE9FE), Color(0xFFFEE2E2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ── Animation Durations ────────────────────────
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration splash = Duration(milliseconds: 2500);
}

// ── Spacing & Sizing ───────────────────────────
class AppSizes {
  AppSizes._();

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXL = 32.0;

  static const double borderRadius = 16.0;
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusLarge = 24.0;

  static const double cardElevation = 2.0;
  static const double iconSize = 24.0;
}

// ── Hive Box Names ─────────────────────────────
class HiveBoxes {
  HiveBoxes._();

  static const String tasks = 'tasks';
  static const String settings = 'settings';
}

// ── Settings Keys ──────────────────────────────
class SettingsKeys {
  SettingsKeys._();

  static const String onboardingComplete = 'onboarding_complete';
  static const String darkMode = 'dark_mode';
}

// ── Motivational Quotes ────────────────────────
class AppQuotes {
  AppQuotes._();

  static const List<String> quotes = [
    "The secret of getting ahead is getting started. — Mark Twain",
    "It always seems impossible until it's done. — Nelson Mandela",
    "Small progress is still progress. ✨",
    "Don't watch the clock; do what it does. Keep going. — Sam Levenson",
    "The only way to do great work is to love what you do. — Steve Jobs",
    "Focus on being productive instead of busy. — Tim Ferriss",
    "You don't have to be great to start, but you have to start to be great.",
    "One task at a time. One day at a time. You've got this! 💪",
    "Productivity is never an accident. It is the result of commitment.",
    "Start where you are. Use what you have. Do what you can.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "Dream big, start small, act now. 🚀",
  ];
}

// ── Filter Categories ──────────────────────────
enum TaskFilter {
  all,
  completed,
  pending,
  highPriority,
}
