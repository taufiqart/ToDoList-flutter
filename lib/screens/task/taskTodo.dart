// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/config/variable.dart';
import 'package:to_do_list/models/TodoModel.dart';

class TaskTodo extends StatefulWidget {
  const TaskTodo({super.key});

  @override
  State<TaskTodo> createState() => _TaskTodoState();
}

class _TaskTodoState extends State<TaskTodo> {
  var todo;
  var _tasks;
  Future<Iterable<TodoModel?>> getTask() async {
    todo = ModalRoute.of(context)!.settings.arguments;
    var db = FirebaseFirestore.instance;
    var tasks = await db
        .collection('todos')
        .doc(todo.uid)
        .collection('tasks')
        .orderBy('order', descending: false)
        .get()
        .then((value) {
      return value.docs.map((snapshot) {
        if (snapshot.data() != null) {
          return TodoModel(
            uid: snapshot.id,
            order: snapshot.data()['order'],
            title: snapshot.data()['title'],
            deskripsi: snapshot.data()['deskripsi'],
            finish: snapshot.data()['finish'],
          );
        }
      });
    });
    _tasks = tasks;
    return tasks;
  }

  void action(type, task) async {
    var db = FirebaseFirestore.instance;
    if (type == 'hapus') {
      await db
          .collection('todos')
          .doc(todo.uid)
          .collection('tasks')
          .doc(task.uid)
          .delete()
          .then((value) {
        setState(() {});
      });
    } else if (type == 'ubah') {
      Navigator.pushNamed(context, editTodoRoute, arguments: {task, todo});
    } else if (type == 'selesai') {
      await db
          .collection('todos')
          .doc(todo.uid)
          .collection('tasks')
          .doc(task.uid)
          .update({'finish': true}).then((value) {
        setState(() {
          _tasks;
        });
      });
    } else if (type == 'belum') {
      await db
          .collection('todos')
          .doc(todo.uid)
          .collection('tasks')
          .doc(task.uid)
          .update({'finish': false}).then((value) {
        setState(() {
          _tasks;
        });
      });
    }
  }

  @override
  void initState() {
    getTask();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (todo == null) {
      todo = ModalRoute.of(context)!.settings.arguments;
    }

    if (TickerMode.of(context)) {
      getTask();
      setState(() {});
    }
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    logoPath,
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
              child: Image.asset(logoPath),
            ),
            SizedBox(width: 10),
            Text(
              appNameText,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Tasks',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  FutureBuilder(
                    future: getTask(),
                    builder: (context, snapshot) {
                      var tasks = snapshot.data;
                      if (snapshot.hasData) {
                        if (tasks!.length > 0) {
                          return Container(
                            width: screen.width,
                            height: screen.height,
                            margin: EdgeInsets.only(top: 10),
                            child: ReorderableListView(
                              onReorder: (oldIndex, newIndex) {
                                // setState(() {
                                //   if (oldIndex > newIndex) newIndex--;
                                //   final item = todos.removeAt(oldIndex);
                                //   todos.insert(newIndex, item);
                                // });
                              },
                              children: [
                                ...tasks.map((task) {
                                  return Container(
                                    key: ValueKey(task?.uid),
                                    width: screen.width,
                                    decoration: BoxDecoration(
                                      color: task!.finish
                                          ? Colors.green.shade200
                                          : Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                          spreadRadius: -5,
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 10,
                                    ),
                                    // height: 50,
                                    clipBehavior: Clip.antiAlias,
                                    alignment: Alignment.center,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor: Colors.grey.shade400,
                                        onTap: () {
                                          print('halo');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${task!.title}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    '${task.deskripsi}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                              DropdownButton(
                                                style: GoogleFonts.poppins(
                                                    color:
                                                        Colors.grey.shade600),
                                                elevation: 0,
                                                borderRadius: BorderRadius.zero,
                                                underline: SizedBox(),
                                                icon: FaIcon(
                                                  FontAwesomeIcons
                                                      .ellipsisVertical,
                                                  color: Colors.grey.shade600,
                                                ),
                                                isExpanded: false,
                                                onChanged: (value) {
                                                  setState(() {
                                                    action(
                                                        value.toString(), task);
                                                    // _txtRole = value.toString();
                                                  });
                                                },
                                                items: [
                                                  'ubah',
                                                  'hapus',
                                                  !task!.finish
                                                      ? 'selesai'
                                                      : 'belum'
                                                ].map((val) {
                                                  return DropdownMenuItem(
                                                    value: val
                                                        .toString()
                                                        .toLowerCase(),
                                                    child: InkWell(
                                                      child: Container(
                                                        width: 50,
                                                        child: Text(val),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Text('belum ada'),
                          );
                        }
                      } else {
                        return Center(
                          child: Text('belum ada'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: (screen.width / 2) - (60 / 2),
              // right: double.infinity,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99999),
                ),
                child: Material(
                  color: Colors.blue,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(99999),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        addTaskTodoRoute,
                        arguments: {'order': _tasks.length, 'todo': todo},
                      );
                    },
                    splashColor: Colors.purple,
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
