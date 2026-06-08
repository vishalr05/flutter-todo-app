// HAND-WRITTEN Hive TypeAdapter for Task model.
// This follows the same pattern as auto-generated adapters from hive_generator.
// We write it manually to avoid the build_runner setup complexity.

part of 'task_model.dart';

/// Hive TypeAdapter for serializing/deserializing [Task] objects.
///
/// Each field is identified by a byte index (matching @HiveField annotations):
///   0: id (String)
///   1: title (String)
///   2: description (String)
///   3: dueDate (DateTime)
///   4: priority (int)
///   5: isCompleted (bool)
///   6: createdAt (DateTime)
class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    // Read the number of fields stored
    final numOfFields = reader.readByte();

    // Read all fields into a map of {fieldIndex: value}
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Construct Task from the field map
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: (fields[2] as String?) ?? '',
      dueDate: fields[3] as DateTime,
      priority: (fields[4] as int?) ?? 0,
      isCompleted: (fields[5] as bool?) ?? false,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    // Write the number of fields first
    writer
      ..writeByte(7) // total number of fields
      ..writeByte(0) // field index for 'id'
      ..write(obj.id)
      ..writeByte(1) // field index for 'title'
      ..write(obj.title)
      ..writeByte(2) // field index for 'description'
      ..write(obj.description)
      ..writeByte(3) // field index for 'dueDate'
      ..write(obj.dueDate)
      ..writeByte(4) // field index for 'priority'
      ..write(obj.priority)
      ..writeByte(5) // field index for 'isCompleted'
      ..write(obj.isCompleted)
      ..writeByte(6) // field index for 'createdAt'
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
