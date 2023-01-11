import 'dart:io';

import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  CameraWidget({Key? key}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  // late File _pickedImage = _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.red,
            child: CircleAvatar(
              radius: 47,
              // backgroundImage:
              //     _pickedImage == null ? null : FileImage(_pickedImage),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 120,
          child: RawMaterialButton(
            fillColor: Colors.red,
            elevation: 30,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        'Choose option',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            InkWell(
                              splashColor: Colors.red,
                              onTap: () {},
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.camera,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.red,
                              onTap: () {},
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              );
            },
            child: Icon(Icons.add_a_photo),
            padding: EdgeInsets.all(15),
            shape: CircleBorder(),
          ),
        )
      ],
    );
  }
}
