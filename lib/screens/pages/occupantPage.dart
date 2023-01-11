// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../read data/get_occupant_id.dart';

class OccupantPage extends StatefulWidget {
  const OccupantPage({super.key});

  @override
  State<OccupantPage> createState() => _OccupantPageState();
}

class _OccupantPageState extends State<OccupantPage> {
  final occupant = FirebaseAuth.instance.currentUser;

  //documents IDs

  List<String> docIDs = [];

  //get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('Occupants')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'List of Occupants',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: prefer_const_constructors
            Text('List of Occupants'),
            Expanded(
                child: FutureBuilder(
              future: getDocId(),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Colors.grey[200],
                          title: GetUserInfo(documentId: docIDs[index]),
                        ),
                      );
                    });
              },
            ))
          ],
        ),
      ),
    );
  }
}
