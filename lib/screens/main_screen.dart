// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estate_portal_copy/screens/pages/drawer_page.dart';
import 'package:estate_portal_copy/services/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final user = FirebaseAuth.instance.currentUser!;

  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  String imageUrl = '';
  // String? name = '';
  // String? email = '';
  // String? street = '';
  // String phoneNo = '';
  // String? entryYear = '';

  // Future _getDataFromDatabase() async {
  //   await FirebaseFirestore.instance
  //       .collection('Occupants')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((snapshot) async {
  //     if (snapshot.exists) {
  //       setState(() {
  //         name = snapshot.data()!['name'];
  //         email = snapshot.data()!['email'];
  //         street = snapshot.data()!['street'];
  //       });
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _getDataFromDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Occupants Dashboard',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //elevation: 0.0,
      ),
      body: SafeArea(
        bottom: true,
        right: true,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(
                children: [
                  Icon(
                    Icons.home,
                    size: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    color: Constants.blueLight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // ignore: prefer_const_constructors
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.email!,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Constants.redDark,
                                child: CircleAvatar(
                                  radius: 45,
                                  child: ClipOval(
                                      child: imageUrl == ''
                                          ? const Icon(
                                              Icons.person,
                                              size: 80,
                                              color: Colors.white,
                                            )
                                          : Image.network(
                                              imageUrl,
                                              width: 160,
                                              height: 160,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 80,
                              left: 80,
                              child: RawMaterialButton(
                                elevation: 10,
                                fillColor: Colors.white,
                                child: Icon(Icons.add_a_photo),
                                padding: EdgeInsets.all(8),
                                shape: CircleBorder(),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        Future.delayed(Duration(seconds: 3),
                                            () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          title: Text(
                                            'Choose option',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    ImagePicker imagePicker =
                                                        ImagePicker();
                                                    XFile? file =
                                                        await imagePicker
                                                            .pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .camera);
                                                    print('${file?.path}');

                                                    if (file == null) return;
                                                    //name of the imagefile to the firebase
                                                    String uniqueFilename =
                                                        DateTime.now()
                                                            .millisecondsSinceEpoch
                                                            .toString();
                                                    //creating a reference to project root
                                                    Reference referenceRoot =
                                                        FirebaseStorage.instance
                                                            .ref()
                                                            .child(user.uid
                                                                .toString());
                                                    Reference
                                                        referenceDirImages =
                                                        referenceRoot
                                                            .child('images');
                                                    //creating a reference for the image to be stored
                                                    Reference
                                                        referenceImageToUpload =
                                                        referenceDirImages
                                                            .child(
                                                                uniqueFilename);

                                                    //to store the file
                                                    try {
                                                      await referenceImageToUpload
                                                          .putFile(
                                                              File(file!.path));

                                                      //if successfull, get URL of uploaded images
                                                      imageUrl =
                                                          await referenceImageToUpload
                                                              .getDownloadURL()
                                                              .then((value) {
                                                        setState(() {
                                                          imageUrl = value;
                                                        });
                                                        return value;
                                                      });
                                                    } on Exception catch (e) {
                                                      // TODO
                                                    }
                                                  },
                                                  icon: Row(
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      Icon(Icons.camera),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'Camera',
                                                        // ignore: prefer_const_constructors
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  )),
                                              IconButton(
                                                  onPressed: () async {
                                                    ImagePicker imagePicker =
                                                        ImagePicker();
                                                    XFile? file =
                                                        await imagePicker
                                                            .pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .gallery);
                                                    print('${file?.path}');

                                                    if (file == null) return;
                                                    //name of the imagefile to the firebase
                                                    String uniqueFilename =
                                                        DateTime.now()
                                                            .millisecondsSinceEpoch
                                                            .toString();
                                                    //creating a reference to project root
                                                    Reference referenceRoot =
                                                        FirebaseStorage.instance
                                                            .ref()
                                                            .child(user.uid
                                                                .toString());
                                                    Reference
                                                        referenceDirImages =
                                                        referenceRoot
                                                            .child('images');
                                                    //creating a reference for the image to be stored
                                                    Reference
                                                        referenceImageToUpload =
                                                        referenceDirImages
                                                            .child(
                                                                uniqueFilename);

                                                    //to store the file
                                                    try {
                                                      await referenceImageToUpload
                                                          .putFile(
                                                              File(file!.path));

                                                      //if successfull, get URL of uploaded images
                                                      imageUrl =
                                                          await referenceImageToUpload
                                                              .getDownloadURL()
                                                              .then((value) {
                                                        setState(() {
                                                          imageUrl = value;
                                                        });
                                                        return value;
                                                      });
                                                    } on Exception catch (e) {
                                                      // TODO
                                                    }
                                                  },
                                                  icon: Row(
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      Icon(Icons.image),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'Gallery',
                                                        // ignore: prefer_const_constructors
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  )),
                                            ]),
                                          ),
                                        );
                                      });
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue),
                                onPressed: () {},
                                child: Text(
                                  'PROFILE',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            Text(
                              user.email!,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            Text(
                              'Gbolahan Ojo',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      height: 30,
                      color: Colors.grey,
                      thickness: 0.9,
                    ),
                    Expanded(
                        child: FutureBuilder(
                            future: getDocId(),
                            builder: ((context, snapshot) {
                              return ListView(children: <Widget>[
                                DataTable(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                      'Name',
                                      style: TextStyle(fontSize: 15),
                                    )),
                                    DataColumn(
                                        label: Text('Gbolahan Ojo',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                  rows: [
                                    // ignore: prefer_const_constructors
                                    DataRow(cells: [
                                      DataCell(Text(
                                        'ID number',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )),
                                      DataCell(Text(user.email!,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Street',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600))),
                                      DataCell(Text('Lane 2',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                    ]),
                                    // ignore: prefer_const_constructors
                                    DataRow(cells: [
                                      DataCell(Text('Phone No',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600))),
                                      DataCell(Text('08087676545',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Entry year',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600))),
                                      DataCell(Text('2019',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                    ]),
                                  ],
                                ),
                              ]);
                            })))
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
      drawer: DrawerPage(),
    );
  }

  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('Occupants')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }
}
