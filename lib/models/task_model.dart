import 'package:hive/hive.dart';

// This file links to the hand-written Hive adapter in task_model.g.dart
part 'task_model.g.dart';

/// Task model representing a single to-do item.
///
/// Uses Hive for local storage persistence. Each field is annotated
/// with @HiveField for serialization. The adapter is in task_model.g.dart.
///
/// Priority levels:
///   0 = Low    (green)
///   1 = Medium (orange)
///   2 = High   (red)
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dueDate;

  /// Priority: 0 = Low, 1 = Medium, 2 = High
  @HiveField(4)
  int priority;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = 0,
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Creates a copy of this task with the given fields replaced.
  /// Useful for immutable updates in the Provider pattern.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns the priority as a human-readable label.
  String get priorityLabel {
    switch (priority) {
      case 2:
        return 'High';
      case 1:
        return 'Medium';
      default:
        return 'Low';
    }
  }
}
