import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Task {
  final int id;
  String title;
  TaskList list; //FIXME: change this to list name? or list id?
  // List<Tag> tags;
  Priority priority;
  bool isDone;
  DateTime dateCreated;
  DateTime dateModified;
  DateTime? dateDue;
  bool? hasDueByTime;
  DateTime? dateDone;

  Task({
    required this.id,
    required this.title,
    required this.list,
    // required this.tags,
    required this.priority,
    required this.isDone,
    required this.dateCreated,
    required this.dateModified,
    this.dateDue,
    this.hasDueByTime,
    this.dateDone,
  });
}

class ImmutableTask extends Equatable {
  final int id;
  final String title;
  final TaskList list;
  // List<Tag> tags;
  final Priority priority;
  final bool isDone;
  final DateTime dateCreated;
  final DateTime dateModified;
  final DateTime? dateDue;
  final bool? hasDueByTime;
  final DateTime? dateDone;

  const ImmutableTask({
    required this.id,
    required this.title,
    required this.list,
    required this.priority,
    required this.isDone,
    required this.dateCreated,
    required this.dateModified,
    this.dateDue,
    this.hasDueByTime,
    this.dateDone,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        list,
        isDone,
        priority,
        dateCreated,
        dateModified,
        dateDue,
        hasDueByTime,
        dateDone,
      ];
}

ImmutableTask createImmutableTask(Task task) {
  return ImmutableTask(
    id: task.id,
    title: task.title,
    list: task.list,
    isDone: task.isDone,
    priority: task.priority,
    dateCreated: task.dateCreated,
    dateModified: task.dateModified,
    dateDue: task.dateDue,
    hasDueByTime: task.hasDueByTime,
    dateDone: task.dateDone,
  );
}

List<ImmutableTask> createImmutableTasks(List<Task> task) {
  List<ImmutableTask> immutableTasks = [];
  for (Task t in task) {
    immutableTasks.add(createImmutableTask(t));
  }
  return List.unmodifiable(immutableTasks);
}

/// Task List Model
class TaskList {
  // final String id;
  final DateTime id;
  Icon icon;
  String name;
  TaskList({
    required this.id,
    required this.icon,
    required this.name,
  });
}

/// Task Tag Model
class Tag {
  final String id;
  Icon icon;
  String name;
  Tag({
    required this.id,
    required this.icon,
    required this.name,
  });
}

/// Contains task priorities
enum Priority implements Comparable<Priority> {
  /// High Priority
  high(value: 0, str: "High", color: Colors.red),

  /// Medium Priority
  medium(value: 1, str: "Medium", color: Colors.yellow),

  /// Low Priority
  low(value: 2, str: "Low", color: Colors.blue),

  /// No Priority
  none(value: 3, str: "No", color: Colors.grey);

  const Priority({
    required this.value,
    required this.str,
    required this.color,
  });

  final int value;
  final String str;
  final MaterialColor color;

  @override
  int compareTo(Priority other) => value - other.value;
}

///PREVIOUS FLAG COLORS ON TASKTILE
// final Color iconColor = priority == Priority.high
//     ? Colors.red.shade600
//     : priority == Priority.medium
//         ? Colors.yellow.shade700
//         : priority == Priority.low
//             ? Colors.blue
//             : Colors.grey.shade500;