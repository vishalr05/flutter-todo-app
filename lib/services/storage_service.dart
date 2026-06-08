import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

/// ──────────────────────────────────────────────
/// Storage Service — Hive local persistence layer
/// ──────────────────────────────────────────────
///
/// Handles all data persistence using Hive:
///   - Task CRUD (Create, Read, Update, Delete)
///   - App settings (onboarding, dark mode)
///   - Mock data seeding for first launch
class StorageService {
  // Singleton pattern for easy access
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Hive box references (initialized in init())
  late Box<Task> _taskBox;
  late Box _settingsBox;

  // ── Initialization ───────────────────────────

  /// Initialize Hive, register adapters, and open boxes.
  /// Must be called before any other storage operations.
  Future<void> init() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Register the Task adapter (from task_model.g.dart)
    Hive.registerAdapter(TaskAdapter());

    // Open the storage boxes
    _taskBox = await Hive.openBox<Task>(HiveBoxes.tasks);
    _settingsBox = await Hive.openBox(HiveBoxes.settings);

    // Seed mock data on first launch
    await _seedMockDataIfEmpty();
  }

  // ── Task Operations ──────────────────────────

  /// Returns all tasks from local storage.
  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  /// Adds a new task to local storage.
  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  /// Updates an existing task in local storage.
  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  /// Deletes a task from local storage by its ID.
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  /// Gets a single task by ID, or null if not found.
  Task? getTask(String id) {
    return _taskBox.get(id);
  }

  // ── Settings Operations ──────────────────────

  /// Returns true if the user has completed onboarding.
  bool getOnboardingComplete() {
    return _settingsBox.get(
      SettingsKeys.onboardingComplete,
      defaultValue: false,
    ) as bool;
  }

  /// Marks onboarding as complete.
  Future<void> setOnboardingComplete(bool value) async {
    await _settingsBox.put(SettingsKeys.onboardingComplete, value);
  }

  /// Returns true if dark mode is enabled.
  bool getDarkMode() {
    return _settingsBox.get(
      SettingsKeys.darkMode,
      defaultValue: false,
    ) as bool;
  }

  /// Sets the dark mode preference.
  Future<void> setDarkMode(bool value) async {
    await _settingsBox.put(SettingsKeys.darkMode, value);
  }

  // ── Mock Data Seeding ────────────────────────

  /// Seeds 10 realistic sample tasks on first launch
  /// so the user can immediately see a functioning app.
  Future<void> _seedMockDataIfEmpty() async {
    if (_taskBox.isNotEmpty) return; // Already has data

    final now = DateTime.now();

    final mockTasks = [
      // ✅ Completed tasks (3)
      Task(
        id: 'mock_1',
        title: 'Buy Groceries',
        description: 'Milk, eggs, bread, fresh vegetables, and fruits from the farmer\'s market',
        dueDate: now,
        priority: 0, // Low
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 'mock_2',
        title: 'Morning Workout',
        description: '30 min cardio + stretching routine at the gym',
        dueDate: now,
        priority: 1, // Medium
        isCompleted: true,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      Task(
        id: 'mock_3',
        title: 'Call Mom',
        description: '',
        dueDate: now,
        priority: 0, // Low
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),

      // 🔴 High priority tasks (3)
      Task(
        id: 'mock_4',
        title: 'Design Portfolio Website',
        description: 'Create a modern portfolio using Flutter Web with responsive layout and smooth animations',
        dueDate: now.add(const Duration(days: 1)),
        priority: 2, // High
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: 'mock_5',
        title: 'Prepare Flutter Presentation',
        description: 'Slides on state management patterns for the team meeting on Friday',
        dueDate: now.add(const Duration(days: 3)),
        priority: 2, // High
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: 'mock_6',
        title: 'Fix Login Bug',
        description: 'Auth token expiration issue causing unexpected logout on app restart. Check refresh token logic.',
        dueDate: now.add(const Duration(days: 1)),
        priority: 2, // High
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),

      // 🟡 Medium priority tasks (2)
      Task(
        id: 'mock_7',
        title: 'Read "Atomic Habits"',
        description: 'Finish chapters 5-8 and take notes on habit stacking techniques',
        dueDate: now.add(const Duration(days: 7)),
        priority: 1, // Medium
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      Task(
        id: 'mock_8',
        title: 'Update Resume',
        description: 'Add recent Flutter projects, update skills section with Hive and Provider',
        dueDate: now.add(const Duration(days: 5)),
        priority: 1, // Medium
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 4)),
      ),

      // 🟢 Low priority tasks (2)
      Task(
        id: 'mock_9',
        title: 'Team Meeting Notes',
        description: 'Document action items and decisions from sprint planning session',
        dueDate: now.add(const Duration(days: 2)),
        priority: 0, // Low
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      Task(
        id: 'mock_10',
        title: 'Organize Desktop Files',
        description: 'Sort downloads folder, archive old projects, clean up screenshots',
        dueDate: now.add(const Duration(days: 4)),
        priority: 0, // Low
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    // Save all mock tasks to Hive
    for (final task in mockTasks) {
      await _taskBox.put(task.id, task);
    }
  }
}
