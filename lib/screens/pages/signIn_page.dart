import 'package:estate_portal_copy/screens/main_screen.dart';
import 'package:estate_portal_copy/screens/pages/forgetPassword.dart';
import 'package:estate_portal_copy/screens/pages/sign_up_page.dart';
import 'package:estate_portal_copy/services/authentication.dart';
import 'package:estate_portal_copy/services/constants.dart';
import 'package:estate_portal_copy/services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required Null Function() onClickedSignUp})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Widget _buildRoomNoRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.verified_user,
              color: Constants.mainColor,
            ),
            labelText: 'Email'),
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

          // ignore: prefer_const_constructors
          decoration: InputDecoration(
              // ignore: prefer_const_constructors
              prefixIcon: Icon(
                Icons.lock,
                color: Constants.mainColor,
              ),
              labelText: 'Password'),
        ));
  }

  Widget _buildForgetPasswordButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Text(
              'Forgot Password?',
              style:
                  TextStyle(decoration: TextDecoration.underline, fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage()));
            },
          )
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(
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
                await signIn();

                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
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
              'Login',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildOrRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 20),
        child: Text(
          '-OR-',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      )
    ]);
  }

  // Widget _buildSocialBtnRow() {
  //   return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
  //     GestureDetector(
  //       onTap: () {},
  //       child: Container(
  //         height: 60,
  //         width: 60,
  //         decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Colors.black26,
  //                   offset: Offset(0, 2),
  //                   blurRadius: 6.0),
  //             ]),
  //         child: Image.asset('assets/images/2 eksu.jpg'),
  //       ),
  //     ),
  //   ]);
  // }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    )
                  ],
                ),
                _buildRoomNoRow(),
                _buildPasswordRow(),
                _buildForgetPasswordButton(),
                _buildLoginButton(),
                // _buildSocialBtnRow(),
                _buildOrRow(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage(
                            showLoginPage: () {},
                          )));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Have you not registered? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    color: Constants.mainColor,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
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
                _buildSignUpBtn()
              ],
            )
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }
}
