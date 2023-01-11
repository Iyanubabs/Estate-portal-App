import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estate_portal_copy/screens/pages/notification.dart';
import 'package:estate_portal_copy/services/constants.dart';
import 'package:estate_portal_copy/models/occupant_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ComplaintPage extends StatefulWidget {
  ComplaintPage({Key? key}) : super(key: key);

  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  TextEditingController occupantName = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      flutterLocalNotificationsPlugin;

  String? ntoken = '';

  @override
  void initState() {
    super.initState();

    requestPermission();
    getToken();
    initInfo();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (String? payload) async {
    //   try {
    //     if (payload != null && payload.isNotEmpty) {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (BuildContext context) {
    //         return Notifications(info: payload.toString());
    //       }));
    //     } else {}
    //   } catch (e) {}
    //   return;
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('...........onMessage............');
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
      );
      NotificationDetails platformChannelSpecifies = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: const IOSNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifies,
          payload: message.data['body']);
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        ntoken = token;
        print('My token is $ntoken');
      });
    });
  }

  void saveToken(String token) async {
    var user;
    await FirebaseFirestore.instance.collection('Occupants').doc(user.uId).set({
      'token': token,
    });
  }

//request permission method
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permision');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional persmission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https//fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAeiR6Dmc:APA91bGrfn_byHAF_CvcDLj5vRHZRm_xzhTmeRIAqS4W0HDnLUtFDkJFINY2LVeuM8okM8cB96pkPfcKZItHi5eJxEVBQA-DcTwp4C6xrRdzCAZZkufsCO6jGLeeA4UQ3jBnIJq0OtRP',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click-action': 'FLUTTER_NTOIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'dbfood'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notification Message'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: occupantName,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(labelText: 'Occupant Name'),
            ),
            TextField(
              controller: title,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(labelText: 'title'),
            ),
            TextField(
              controller: body,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(labelText: 'body'),
            ),
            GestureDetector(
              onTap: () async {
                String name = occupantName.text.trim();
                String titleText = title.text;
                String bodyText = body.text;

                if (name != '') {
                  DocumentSnapshot snap = await FirebaseFirestore.instance
                      .collection('Occupants')
                      .doc(name)
                      .get();

                  String token = snap['token'];
                  print(token);

                  sendPushMessage(token, titleText, bodyText);
                }
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
      )),
    );
  }
}
