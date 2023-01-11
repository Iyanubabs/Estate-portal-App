import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class GetUserInfo extends StatelessWidget {
  final String documentId;
  GetUserInfo({required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference occupants =
        FirebaseFirestore.instance.collection('Occupants');
    return FutureBuilder<DocumentSnapshot>(
        future: occupants.doc(documentId).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text('${data['name']}' +
                '|' +
                '${data['street']}' +
                '|' +
                '0' +
                '${data['phoneNo']}');
          }
          return Text('loading...');
        })));
  }
}
