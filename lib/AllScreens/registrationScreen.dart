import 'package:callcab/AllScreens/loginScreen.dart';
import 'package:callcab/AllScreens/mainscreen.dart';
import 'package:callcab/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:callcab/AllWidgets/progressDialog.dart';

class registrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                  height: 25.0,
                ),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 200.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),
                Text(
                  "Sign up as a Passenger",
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
                        height: 10.0,
                      ),
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Name",
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
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Enter Phone No.",
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
                              "Create Account",
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
                          if (nameTextEditingController.text.length < 4) {
                            displayToastMessage(
                                "Name should be a minimum of 4 characters",
                                context);
                          } else if (!emailTextEditingController.text
                              .contains("@")) {
                            displayToastMessage(
                                "Email address is not valid", context);
                          } else if (phoneTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Phone number cannot be left empty", context);
                          } else if (passTextEditingController.text.length <
                              6) {
                            displayToastMessage(
                                "Password should be a minimum of 6 characters",
                                context);
                          } else {
                            registerNewUser(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text(
                    "Already have an account? Login here",
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

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Creating new user...");
        });
    final User? user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passTextEditingController.text,
    )
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;
    if (user != null) {
      // save user info to database
      usersRef.child(user.uid);
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      usersRef.child(user.uid).set(userDataMap);
      displayToastMessage("Congrats, your account has been created", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      // error occured - display error message
      displayToastMessage("New user account has not been created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(
      msg:
          message); //this function is created so that it can be used multiple times without using many words
}
