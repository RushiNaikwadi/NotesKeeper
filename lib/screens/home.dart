import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/screens/AddTask.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? UID;

  @override
  void initState() {
    super.initState();
    getUID();
  }

  getUID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    setState(() {
      UID = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To Do',
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(3, 4, 3, 0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.purple,
          child: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tasks').doc(UID).collection('myTasks').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitRing(
                    color: Colors.white,
                    size: 75,
                  );
                } else {
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.grey[900],
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: Text(
                                          docs[index]['Title'],
                                          textScaleFactor: 1.1,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent,
                                            fontFamily: 'RobotoSlab',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: Text(
                                          docs[index]['Description'],
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                            fontFamily: 'Lobster',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                        alignment: Alignment.bottomRight,
                                        child:FloatingActionButton.small(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance.collection('tasks').doc(UID).collection('myTasks').doc(docs[index]['Time']).delete();
                                          },
                                          backgroundColor: Colors.grey[900],
                                          elevation: 0,
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                ),
                              ),
                            ),
                        );
                      }
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
          },
          icon: const Icon(
            Icons.add,
            color: Colors.yellow
          ),
          label: const Text(
            'Add Task',
            style: TextStyle(
                color: Colors.yellow,
            ),
          ),
          backgroundColor: Colors.blue[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
