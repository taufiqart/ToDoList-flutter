import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/config/variable.dart';

class AddTaskTodo extends StatefulWidget {
  const AddTaskTodo({super.key});

  @override
  State<AddTaskTodo> createState() => _AddTaskTodoState();
}

class _AddTaskTodoState extends State<AddTaskTodo> {
  var order;
  var todo;
  var args;
  final _formKey = GlobalKey<FormState>();
  var _txtTitle = TextEditingController();
  var _txtDeskripsi = TextEditingController();
  double spaceField = 4;
  void submit() async {
    var db = FirebaseFirestore.instance;
    await db.collection('todos').doc(todo.uid).collection('tasks').add({
      'title': _txtTitle.text,
      'deskripsi': _txtDeskripsi.text,
      'finish': false,
      'order': order,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments;
    order = args['order'];
    todo = args['todo'];
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  addTaskTodoText,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          controller: _txtTitle,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.blue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.blue.shade500,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.blue.shade500,
                                width: 1.2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.pink.shade400,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 10,
                            ),
                            errorStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              height: 0.5,
                            ),
                            fillColor: Colors.white70,
                            filled: true,
                            hintText: titleText,
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == '') {
                              return titleEmpty;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: spaceField * 2,
                        ),
                        TextFormField(
                          maxLines: null,
                          // expands: true,
                          keyboardType: TextInputType.multiline,
                          controller: _txtDeskripsi,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.blue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.blue.shade500,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.blue.shade500,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Colors.pink.shade400,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 10,
                            ),
                            errorStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              height: 0.5,
                            ),
                            fillColor: Colors.white70,
                            filled: true,
                            hintText: deskripsiText,
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // Spacer(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      transform: GradientRotation(1),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        submit();
                      },
                      splashColor: Colors.blue,
                      child: Container(
                        height: 50,
                        width: screen.width,
                        alignment: Alignment.center,
                        child: Text(
                          addText,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
