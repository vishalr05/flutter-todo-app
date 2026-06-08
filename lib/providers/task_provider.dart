import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

/// ──────────────────────────────────────────────
/// Task Provider — Central state management
/// ──────────────────────────────────────────────
///
/// Manages the task list, filtering, and search.
/// All changes are persisted to Hive automatically.
class TaskProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  // ── State ────────────────────────────────────

  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';

  // ── Getters ──────────────────────────────────

  /// The current active filter.
  TaskFilter get filter => _filter;

  /// The current search query.
  String get searchQuery => _searchQuery;

  /// Total number of tasks.
  int get totalTasks => _tasks.length;

  /// Number of completed tasks.
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;

  /// Number of pending (incomplete) tasks.
  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;

  /// Completion percentage (0.0 to 1.0) for the progress bar.
  double get completionPercentage {
    if (_tasks.isEmpty) return 0.0;
    return completedTasks / totalTasks;
  }

  /// Returns the filtered and searched task list.
  /// Tasks are sorted: incomplete first (by due date), then completed.
  List<Task> get filteredTasks {
    // Step 1: Apply category filter
    List<Task> result;
    switch (_filter) {
      case TaskFilter.completed:
        result = _tasks.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.pending:
        result = _tasks.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.highPriority:
        result = _tasks.where((t) => t.priority == 2).toList();
        break;
      case TaskFilter.all:
      default:
        result = List.from(_tasks);
    }

    // Step 2: Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    // Step 3: Sort — incomplete tasks first (by due date), then completed
    result.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1; // Incomplete first
      }
      return a.dueDate.compareTo(b.dueDate); // Earlier due date first
    });

    return result;
  }

  // ── Data Loading ─────────────────────────────

  /// Load all tasks from Hive storage.
  /// Called once during app initialization.
  void loadTasks() {
    _tasks = _storage.getAllTasks();
    notifyListeners();
  }

  // ── CRUD Operations ──────────────────────────

  /// Add a new task and persist it.
  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _storage.addTask(task);
    notifyListeners();
  }

  /// Update an existing task and persist changes.
  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _storage.updateTask(updatedTask);
      notifyListeners();
    }
  }

  /// Delete a task by ID and persist the removal.
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _storage.deleteTask(id);
    notifyListeners();
  }

  /// Toggle the completion status of a task.
  Future<void> toggleComplete(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      await _storage.updateTask(_tasks[index]);
      notifyListeners();
    }
  }

  // ── Filtering & Search ───────────────────────

  /// Set the active filter category.
  void setFilter(TaskFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  /// Set the search query string.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear the search query.
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
