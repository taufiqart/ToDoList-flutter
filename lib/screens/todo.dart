// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/config/variable.dart';
import 'package:to_do_list/models/TodoModel.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  var _todos;
  Future<Iterable<TodoModel?>> getTodos() async {
    var db = FirebaseFirestore.instance;
    var todos = await db
        .collection('todos')
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
          );
        }
      });
    });
    _todos = todos;
    return todos;
  }

  void addTodo() async {
    var db = FirebaseFirestore.instance;
    await db.collection('todos').add({
      'title': '',
    });
  }

  void action(type, todo) async {
    var db = FirebaseFirestore.instance;
    if (type == 'hapus') {
      await db.collection('todos').doc(todo.uid).delete().then((value) {
        setState(() {});
      });
    } else if (type == 'ubah') {
      Navigator.pushNamed(context, editTodoRoute, arguments: todo);
    }
  }

  @override
  void initState() {
    getTodos();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (TickerMode.of(context)) {
      getTodos();
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
                    'Todo List',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FutureBuilder(
                    future: getTodos(),
                    builder: (context, snapshot) {
                      var todos = snapshot.data;
                      if (snapshot.hasData) {
                        if (todos!.length > 0) {
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
                                ...todos.map((todo) {
                                  return Container(
                                    key: ValueKey(todo?.uid),
                                    width: screen.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                          Navigator.pushNamed(
                                              context, taskTodoRoute,
                                              arguments: todo);
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
                                                    '${todo!.title}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    '${todo.deskripsi}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              DropdownButton(
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
                                                        value.toString(), todo);
                                                    // _txtRole = value.toString();
                                                  });
                                                },
                                                style: GoogleFonts.poppins(
                                                    color:
                                                        Colors.grey.shade600),
                                                items: ['ubah', 'hapus']
                                                    .map((val) {
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
                          return Container(
                            height: screen.height * 0.8,
                            child: Center(
                              child: Text('belum ada'),
                            ),
                          );
                        }
                      } else {
                        return Container(
                          height: screen.height * 0.8,
                          child: Center(
                            child: Text('belum ada'),
                          ),
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
                        addTodoRoute,
                        arguments: _todos.length,
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
