import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/config/variable.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:to_do_list/screens/addTodo.dart';
import 'package:to_do_list/screens/editTodo.dart';
import 'package:to_do_list/screens/task/taskTodo.dart';
import 'package:to_do_list/screens/task/addTaskTodo.dart';
import 'package:to_do_list/screens/task/editTaskTodo.dart';
import 'package:to_do_list/screens/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: ToDo(),
      routes: {
        todoRoute: (context) => ToDo(),
        addTodoRoute: (context) => AddTodo(),
        editTodoRoute: (context) => EditTodo(),
        taskTodoRoute: (context) => TaskTodo(),
        addTaskTodoRoute: (context) => AddTaskTodo(),
        editTaskTodoRoute: (context) => EditTaskTodo(),
      },
    );
  }
}
