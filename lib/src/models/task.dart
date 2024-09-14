import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Task {
  final int id;
  String title;
  bool isDone;
  Priority priority;
  DateTime dateCreated;
  DateTime dateModified;
  DateTime? dateDue;
  bool? hasDueByTime;
  DateTime? dateDone;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.priority,
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
  final bool isDone;
  final Priority priority;
  final DateTime dateCreated;
  final DateTime dateModified;
  final DateTime? dateDue;
  final bool? hasDueByTime;
  final DateTime? dateDone;

  const ImmutableTask({
    required this.id,
    required this.title,
    required this.isDone,
    required this.priority,
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
    isDone: task.isDone,
    priority: task.priority,
    dateCreated: task.dateCreated,
    dateModified: task.dateModified,
    dateDue: task.dateDue,
    hasDueByTime: task.hasDueByTime,
    dateDone: task.dateDone,
  );
}

enum Priority implements Comparable<Priority> {
  /// High Priority
  high(value: 0, str: "High", color: Colors.red),

  /// Medium Priority
  medium(value: 1, str: "Medium", color: Colors.yellow),

  /// Low Priority
  low(value: 2, str: "Low", color: Colors.blue),

  /// No Priority
  none(value: 3, str: "None", color: Colors.grey);

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
