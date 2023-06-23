import 'package:to_do_list/models/TaskModel.dart';

class TodoModel {
  String uid;
  int order;
  String title;
  String? deskripsi;
  List<TaskModel>? tasks;
  bool finish;
  TodoModel({
    required this.uid,
    required this.order,
    required this.title,
    this.deskripsi,
    this.finish = false,
    this.tasks,
  });
}
