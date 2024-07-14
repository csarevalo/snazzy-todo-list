import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:todo_list/screens/add_task_dialog.dart';

import 'screens/home_screen.dart';
import 'providers/task_provider.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Snazzy To-Do List",
        initialRoute: '/',
        routes: {
          '/': (ctx) => HomeScreen(),
          // '/add-task': (ctx) => AddTaskDialog(),
        },
        // home: HomeScreen(),
      ),
    );
  }
}
