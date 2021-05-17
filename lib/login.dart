import 'package:demorestaurant/dashboard.dart';
import 'package:demorestaurant/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialogs.dart';

TextEditingController lemail = TextEditingController();
String lemailerror;

TextEditingController lpass = TextEditingController();
String lpasserror;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

User user;
SharedPreferences logindetails;

class LoginState extends State {
  @override
  void initState() {
    super.initState();
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async => {
              Navigator.pop(context),
              user = FirebaseAuth.instance.currentUser,
              if (user.emailVerified == false)
                {user.sendEmailVerification(), toast("verify email", false)}
              else if (user.emailVerified == true)
                {
                  logindetails = await SharedPreferences.getInstance(),
                  logindetails.setString("uid", user.uid),
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Dashboard()))
                }
            })
        .catchError(
            (e) => {Navigator.pop(context), toast(e.toString(), false)});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            elevation: 0,
          ),
          body: SingleChildScrollView(
              child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                    ),
                    Center(
                        child: Text(
                      "Login Form...",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: lemail,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail,
                      ),
                      labelText: "Email *",
                      hintText: "Eg : John@gmail.com",
                      errorText: lemailerror,
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: lpass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.remove_red_eye_outlined,
                      ),
                      labelText: "Password *",
                      hintText: "Eg : John@123",
                      errorText: lpasserror,
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                    ),
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            this.setState(() {
                              if (lemail.text.trim().isEmpty) {
                                lemailerror = "Enter email";
                                return;
                              } else {
                                lemailerror = null;

                                FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: lemail.text.trim())
                                    .then((value) =>
                                        {toast("Reset email sent", true)})
                                    .catchError((e) {
                                  toast(e.toString(), false);
                                });
                              }
                            });
                          },
                          child: Text(
                            "Forgot Password ? ",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.orange),
                          onPressed: () {
                            this.setState(() {
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(lemail.text);
                              if (lemail.text.trim().isEmpty) {
                                lemailerror = "Enter email";
                                return;
                              } else if (emailValid == false) {
                                lemailerror = "Enter valid email";
                                return;
                              } else {
                                lemailerror = null;
                              }

                              if (lpass.text.trim().isEmpty) {
                                lpasserror = "Enter password";
                                return;
                              } else {
                                lpasserror = null;
                                showLoaderDialog(context);
                                login(lemail.text.trim().toLowerCase(),
                                    lpass.text.trim());
                              }
                            });
                          },
                          child: Text("Login"))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account ? "),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Text(
                          "Register Here",
                          style: TextStyle(color: Colors.orange),
                        ))
                  ],
                ),
              ],
            ),
          )),
        ));
  }
}
