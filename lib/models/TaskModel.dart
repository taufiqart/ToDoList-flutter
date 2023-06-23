class TaskModel {
  String uid;
  int order;
  String title;
  String? deskripsi;
  bool finish;

  TaskModel({
    required this.uid,
    required this.order,
    required this.title,
    this.deskripsi,
    this.finish = false,
  });
}
