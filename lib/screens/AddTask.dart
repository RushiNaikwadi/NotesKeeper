import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/screens/home.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTasktoFirebase() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final User user = await auth.currentUser!;
      String uid = user.uid;
      var time = DateTime.now();
      await FirebaseFirestore.instance.
      collection('tasks').
      doc(uid).
      collection('myTasks').
      doc(time.toString()).
      set({
        'Title': titleController.text,
        'Description': descriptionController.text,
        'Time': time.toString(),
        'timeStamp': time
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Task',
        ),
        centerTitle: true,
      ),
      body: Container(
        // color: Colors.grey,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
              Container(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(),
                    ),
                    label: Text('Title'),
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                child: TextField(
                  maxLines: 7,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(),
                    ),
                    label: const Text('Description'),
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: 350,
                child: FloatingActionButton.small(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    addTasktoFirebase();
                  },
                  child: Icon(
                    Icons.add,
                  )
                ),
              )
          ],
        )
      ),
    );
  }
}
