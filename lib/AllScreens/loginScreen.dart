import 'package:callcab/Allscreens/registrationScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:callcab/AllWidgets/progressDialog.dart';

import '../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 45.0,
                ),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 200.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),
                Text(
                  "Login as a Passenger",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: "bolt semibold",
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        controller: passTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        color: Colors.yellow,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Brand Bold",
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@")) {
                            displayToastMessage(
                                "You have entered an invalid email id",
                                context);
                          } else if (passTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Password is mandatory to login", context);
                          } else if (emailTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Email is mandatory to login", context);
                          } else {
                            loginAndAuthenticateUser(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, registrationScreen.idScreen, (route) => false);
                  },
                  child: Text(
                    "Do not have an account? Register here",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authenticating...");
        });
    final User? user = (await _firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passTextEditingController.text,
    )
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;
    if (user != null) {
      usersRef.child(user.uid).once().then((value) => (DataSnapshot snap) {
            if (snap.value != null) {
              Navigator.pushNamedAndRemoveUntil(
                  context, MainScreen.idScreen, (route) => false);
              displayToastMessage("You are logged in", context);
            } else {
              Navigator.pop(context);
              _firebaseAuth.signOut();
              displayToastMessage(
                  "No record exists for this user /n Please create new account",
                  context);
            }
          });

      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      // error occured - display error message
      Navigator.pop(context);
      displayToastMessage("Error Occured. Please try again", context);
    }
  }
}
