import 'dart:io';

import 'package:estate_portal_copy/screens/main_screen.dart';
import 'package:estate_portal_copy/screens/pages/complaint.dart';
import 'package:estate_portal_copy/screens/pages/complaint_page.dart';
import 'package:estate_portal_copy/screens/pages/forgetPassword.dart';
import 'package:estate_portal_copy/screens/pages/home_page.dart';
import 'package:estate_portal_copy/screens/pages/occupantPage.dart';
import 'package:estate_portal_copy/screens/pages/security.dart';
import 'package:estate_portal_copy/screens/pages/signIn_page.dart';
import 'package:estate_portal_copy/services/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class ButtonsInfo {
  String title;
  IconData icon;
  Function onTap;

  ButtonsInfo({required this.title, required this.icon, required this.onTap});
}

int _currentIndex = 0;

List<ButtonsInfo> _buttonNames = [
  ButtonsInfo(title: 'Dashboard', icon: Icons.home, onTap: () => {}),
  ButtonsInfo(title: 'Notifications', icon: Icons.notifications, onTap: () {}),
  ButtonsInfo(title: 'Payment', icon: Icons.sell, onTap: () {}),
  ButtonsInfo(
      title: 'Complaints',
      icon: Icons.mark_email_read,
      onTap: () {
        (BuildContext context) => ComplaintPage();
      }),
  ButtonsInfo(title: 'New Message', icon: Icons.message, onTap: () {}),
  ButtonsInfo(title: 'Security', icon: Icons.verified_user, onTap: () {}),
  ButtonsInfo(
      title: 'Neighbours',
      icon: Icons.supervised_user_circle_rounded,
      onTap: () {}),
  ButtonsInfo(
      title: 'Change password', icon: Icons.password_outlined, onTap: () {}),
  ButtonsInfo(
      title: 'Logout', icon: Icons.arrow_back_ios_new_sharp, onTap: () {}),
];

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Constants.blueLight,
        child: ListView(
          children: <Widget>[
            // title: Padding(

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'MENU',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Dashbaord',
                    icon: Icons.home,
                    onClicked: () => selectedItem(context, 0),
                  ),

                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Complaint',
                    icon: Icons.mark_email_read,
                    onClicked: () => selectedItem(context, 1),
                  ),

                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Security',
                    icon: Icons.verified_user,
                    onClicked: () => selectedItem(context, 2),
                  ),

                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Neighbours',
                    icon: Icons.people,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 8),
                  // buildMenuItem(
                  //   text: 'Settings',
                  //   icon: Icons.settings,
                  //   onClicked: () => selectedItem(context, 7),
                  // ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Change password',
                    icon: Icons.password_outlined,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.arrow_back_ios_new_sharp,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Go Back Home',
                    icon: Icons.home_outlined,
                    onClicked: () => selectedItem(context, 6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(text, style: TextStyle(color: color)),
          hoverColor: hoverColor,
          onTap: onClicked,
        ),
        Divider(
          color: Colors.white,
          thickness: 0.3,
        )
      ],
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainPage(),
        ));
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Complaint(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SecurityPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (context) => OccupantPage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (context) => ForgotPasswordPage(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginPage(onClickedSignUp: () {})));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (context) => HomePage(),
        ));
    }
  }
}
