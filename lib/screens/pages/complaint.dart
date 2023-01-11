import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estate_portal_copy/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  String? get currentId => null;

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  final _occupantNameController = TextEditingController();
  final _houseNoController = TextEditingController();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _occupantNameController.dispose();
    _houseNoController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _occupantNameController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(labelText: 'Occupant Name'),
              ),
              TextFormField(
                controller: _houseNoController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(labelText: 'House No'),
              ),
              TextField(
                controller: _titleController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(labelText: 'title'),
              ),
              TextField(
                controller: _messageController,
                maxLines: 8,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(labelText: 'message'),
              ),
              GestureDetector(
                onTap: () async {
                  String name = _occupantNameController.text;
                  String title = _titleController.text;

                  String message = _messageController.text;
                  _occupantNameController.clear();
                  _houseNoController.clear();
                  _titleController.clear();
                  _messageController.clear();
                  await FirebaseFirestore.instance
                      .collection('Complaints')
                      .doc('Message history')
                      .collection('message history')
                      .add({
                    "name": name,
                    "title": title,
                    "messages": message,
                    "date": DateTime.now(),
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection('Complaints')
                        .doc('Last message')
                        .set({
                      "occupant_name": name,
                      "title": title,
                      "last_msg": message,
                      "date": DateTime.now(),
                    });
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Constants.purpleLight.withOpacity(0.5),
                        )
                      ]),
                  // ignore: prefer_const_constructors
                  child: Center(
                      child: const Text(
                    'SEND',
                    style: TextStyle(
                        color: Constants.offWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
