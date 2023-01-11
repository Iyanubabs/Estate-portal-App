// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estate_portal_copy/screens/pages/signIn_page.dart';
import 'package:estate_portal_copy/services/authentication.dart';
import 'package:estate_portal_copy/services/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? name;
  late String password;
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _houseNoController = TextEditingController();
  final _entryYearController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _streetController = TextEditingController();

  get onClickedSignUp => null;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _nameController.dispose();
    _houseNoController.dispose();
    _entryYearController.dispose();
    _phoneNoController.dispose();
    _streetController.dispose();

    super.dispose();
  }

  Future signUp() async {
    bool isLOggedINFalse = false;
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      //add occupant details
      addOccupantDetails(
          _nameController.text.trim(),
          _emailController.text.trim(),
          int.parse(_houseNoController.text.trim()),
          int.parse(_phoneNoController.text.trim()),
          int.parse(_entryYearController.text.trim()),
          _streetController.text.trim());
    }
  }

  Future addOccupantDetails(String name, String email, int houseNo, int phoneNo,
      int entryYear, String street) async {
    await FirebaseFirestore.instance.collection('Occupants').add({
      'name': name,
      'email': email,
      'houseNo': houseNo,
      'phoneNo': phoneNo,
      'entryYear': entryYear,
      'street': street,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: const EdgeInsets.symmetric(vertical: 70)),
        Text(
          'ESTATE PORTAL',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        )
      ],
    );
  }

  Widget _buildNameRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _nameController,
        enabled: false,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        decoration: InputDecoration(labelText: 'Full Name'),
      ),
    );
  }

  Widget _buildRoomNoRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _houseNoController,
        keyboardType: TextInputType.text,
        onChanged: (value) async {
          if (value.length == 9) {
            _nameController.text = await AuthenticationService().getName(value);

            print('$name');
          }
        },
        decoration: InputDecoration(labelText: 'House No'),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: _passwordController,
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Constants.mainColor,
              ),
              labelText: 'Password'),
        ));
  }

  Widget _buildConfirmPasswordRow() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: _confirmpasswordController,
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Constants.mainColor,
              ),
              labelText: 'Confirm Password'),
        ));
  }

  Widget _buildEmailRow() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Email'),
        ));
  }

  Widget _buildEntryYearRow() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: _entryYearController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Entry Year'),
        ));
  }

  Widget _buildStreetRow() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: _streetController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Street'),
        ));
  }

  Widget _buildPhoneNoRow() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: _phoneNoController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Phone Number'),
        ));
  }

  Widget _buildSignUpButton() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 1.4 * (MediaQuery.of(context).size.height / 20),
            width: 5 * (MediaQuery.of(context).size.width / 10),
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Constants.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
              onPressed: () async {
                try {
                  await signUp();

                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  onClickedSignUp: () {},
                                )));
                  }
                } on FirebaseAuthException catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(e.message.toString()),
                        );
                      });
                }
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: MediaQuery.of(context).size.height / 40,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(color: Colors.white),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Register as a new Occupant',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40,
                          ),
                        )
                      ],
                    ),
                    _buildNameRow(),
                    _buildRoomNoRow(),
                    _buildEmailRow(),
                    _buildPhoneNoRow(),
                    _buildEntryYearRow(),
                    _buildStreetRow(),
                    _buildPasswordRow(),
                    _buildConfirmPasswordRow(),
                    _buildSignUpButton(),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(70),
                          bottomRight: const Radius.circular(70))),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildLogo(),
                  _buildContainer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
