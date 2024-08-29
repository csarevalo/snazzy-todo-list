import 'package:flutter/material.dart';

import 'src/providers/task_provider.dart';
import 'src/providers/settings_controller.dart';
import 'src/utils/settings_service.dart';
import 'src/todo_app.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  final taskProvider = TaskProvider(TaskProviderService());
  await taskProvider.init();
  runApp(TodoApp(
    settingsController: settingsController,
    taskProvider: taskProvider,
  ));
}
