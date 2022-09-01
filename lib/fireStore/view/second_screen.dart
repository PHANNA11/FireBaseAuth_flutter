import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase6_7/fireStore/model/student_model.dart';
import 'package:firebase6_7/fireStore/view/custom_student_widget.dart';
import 'package:firebase6_7/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController scoreController = TextEditingController();

  List<String> docIds = [];
  final CollectionReference _student =
      FirebaseFirestore.instance.collection('student');
  Future getDocID() async {
    await FirebaseFirestore.instance
        .collection('student')
        .get()
        .then((value) => value.docs.forEach((element) {
              print('DocID=${element.reference.id}');
              docIds.add(element.reference.id);
            }));
  }

  Future createStudent({Student? student}) async {
    try {
      var studentdoc = FirebaseFirestore.instance.collection('student').doc();
      final json = student!.toJson();
      await studentdoc.set(json);
    } catch (e) {
      print(e);
    }
  }

  var firedata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firedata = getDocID();
    idController.text = Random().nextInt(100).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to login'),
        actions: [
          MaterialButton(
            onPressed: () async {
              messageLogOut();
            },
            child: const Text('SignOut'),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                          hintText: 'id', border: OutlineInputBorder())),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          hintText: 'Enter name',
                          border: OutlineInputBorder())),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: genderController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Gender',
                          border: OutlineInputBorder())),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: scoreController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Score',
                          border: OutlineInputBorder())),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              //color: Colors.blue,
              child: FutureBuilder(
                future: firedata,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Icon(
                        Icons.info,
                        size: 30,
                        color: Colors.red,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: docIds.length,
                    itemBuilder: (context, index) {
                      return StudentWidget(documentId: docIds[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CupertinoButton(
              color: Colors.red,
              child: const Text('clear'),
              onPressed: () {
                setState(() {
                  idController.text = Random().nextInt(100).toString();
                  nameController.text = '';
                  genderController.text = '';
                  scoreController.text = '';
                });
              },
            ),
          ),
          Expanded(
            child: CupertinoButton(
              color: Theme.of(context).primaryColor,
              child: const Text('save'),
              onPressed: () async {
                await createStudent(
                        student: Student(
                            id: int.parse(idController.text),
                            name: nameController.text,
                            gender: genderController.text,
                            score: double.parse(scoreController.text)))
                    .whenComplete(() {
                  setState(() {
                    docIds.clear();
                    firedata = getDocID();
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> messageLogOut() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Do you want to sign out??'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel')),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .signOut()
                        .whenComplete(() => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(
                                title: 'Home page',
                              ),
                            ),
                            (route) => false));
                  },
                  child: const Text('ok')),
            ],
          );
        });
  }
}
