// import 'package:estate_portal/pages/occupant_signin_page.dart';
// import 'package:estate_portal/screens/home_page.dart';

// import 'package:estate_portal/screens/main_screen.dart';
// import 'package:estate_portal/services/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// ignore_for_file: prefer_const_constructors, duplicate_ignore, unused_import, library_private_types_in_public_api, annotate_overrides

import 'package:estate_portal_copy/screens/pages/home_page.dart';
import 'package:estate_portal_copy/screens/pages/signIn_page.dart';
import 'package:estate_portal_copy/services/constants.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomePage())));
  }

  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        backgroundColor: Constants.purpleDark,
        // ignore: prefer_const_constructors
        body: Center(
          // ignore: prefer_const_constructors
          child: Text(
            'WELCOME',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ));
  }
}
