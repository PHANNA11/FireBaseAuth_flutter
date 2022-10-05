// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class StudentWidget extends StatelessWidget {
  StudentWidget({required this.documentId, Key? key}) : super(key: key);
  String documentId;

  @override
  Widget build(BuildContext context) {
    CollectionReference stu = FirebaseFirestore.instance.collection('student');
    return FutureBuilder<DocumentSnapshot>(
      future: stu.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return InkWell(
            onLongPress: () async {
              await stu.doc(documentId).delete();
            },
            child: Card(
              color: Color.fromARGB(255, 241, 215, 213),
              child: ListTile(
                title: Text(data['name'].toString()),
              ),
            ),
          );
        }
        return ListTile(
          title: Text('Loading....'),
        );
      },
    );
  }
}
