import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dialogs.dart';
import 'login.dart';

TextEditingController rname = TextEditingController();
String rnameerror;

TextEditingController remail = TextEditingController();
String remailerror;

TextEditingController rphone = TextEditingController();
String rphoneerror;

TextEditingController rpass = TextEditingController();
String rpasserror;

TextEditingController crpass = TextEditingController();
String crpasserror;

String matcherror = "";

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State {
  void initState() {
    super.initState();
  }

  void register(
      String email, String password, String name, String phone) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((snapshot) async {
      FirebaseAuth.instance.currentUser
          .sendEmailVerification()
          .then((value) => {toast("Email verification sent", true)});
      var userid = FirebaseAuth.instance.currentUser.uid;

      await FirebaseDatabase.instance
          .reference()
          .child("restaurant")
          .child("users")
          .child(userid)
          .set({
            "email": email,
            "name": name,
            "phone": phone,
          })
          .then((value) => {
                Navigator.pop(context),
                toast(email.toString() + " Registred successfull", true),
                rname.clear(),
                remail.clear(),
                rphone.clear(),
                rpass.clear(),
                crpass.clear(),
              })
          .catchError((e) => {
                Navigator.pop(context),
                toast(e.toString(), false),
              });
    }).catchError((e) => {
              Navigator.pop(context),
              toast(e.toString(), false),
              rname.clear(),
              remail.clear(),
              rphone.clear(),
              rpass.clear(),
              crpass.clear(),
            });
  }

  Future<bool> backPressed() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: backPressed,
        child: MaterialApp(
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
                          "Registration Form...",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ))
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 50)),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: rname,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: "Name *",
                          hintText: "Eg : John",
                          errorText: rnameerror,
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: remail,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                          ),
                          labelText: "Email *",
                          hintText: "Eg : John@gmail.com",
                          errorText: remailerror,
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
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: rphone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                          labelText: "Phone *",
                          hintText: "Eg : 9876543210",
                          errorText: rphoneerror,
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)),
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: rpass,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.remove_red_eye_outlined,
                          ),
                          labelText: "Password *",
                          hintText: "Eg : John@123",
                          errorText: rpasserror,
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
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: crpass,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.remove_red_eye_outlined,
                          ),
                          labelText: "Re-Type Password *",
                          hintText: "Eg : John@123",
                          errorText: crpasserror,
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
                    Text(
                      matcherror,
                      style: TextStyle(color: Colors.red),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange),
                              onPressed: () {
                                this.setState(() {
                                  if (rname.text.trim().isEmpty) {
                                    rnameerror = "Enter name";
                                    return;
                                  } else {
                                    rnameerror = null;
                                  }

                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(remail.text);
                                  if (remail.text.trim().isEmpty) {
                                    remailerror = "Enter email";
                                    return;
                                  } else if (emailValid == false) {
                                    remailerror = "Enter valid email";
                                    return;
                                  } else {
                                    remailerror = null;
                                  }

                                  if (rphone.text.trim().isEmpty) {
                                    rphoneerror = "Enter phone number";
                                    return;
                                  } else if (rphone.text.trim().length < 10) {
                                    rphoneerror = "Enter valid number";
                                    return;
                                  } else {
                                    rphoneerror = null;
                                  }

                                  if (rpass.text.trim().isEmpty) {
                                    rpasserror = "Enter password";
                                    return;
                                  } else if (rpass.text.trim().length < 6) {
                                    rpasserror =
                                        "Password must be atleast 6 char";
                                    return;
                                  } else {
                                    rpasserror = null;
                                  }

                                  if (crpass.text.trim().isEmpty) {
                                    crpasserror = "Enter password";
                                    return;
                                  } else if (crpass.text.trim().length < 6) {
                                    crpasserror =
                                        "Password must be atleast 6 char";
                                    return;
                                  } else {
                                    crpasserror = null;
                                  }

                                  if (crpass.text.trim() == rpass.text.trim()) {
                                    matcherror = "";
                                    showLoaderDialog(context);
                                    register(
                                        remail.text.trim().toLowerCase(),
                                        rpass.text.trim(),
                                        rname.text.trim(),
                                        rphone.text.trim());
                                  } else {
                                    matcherror =
                                        "Password and Confirm password does not match";
                                  }
                                });
                              },
                              child: Text("Register"))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account ? "),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text("Login Here",
                                style: TextStyle(color: Colors.orange)))
                      ],
                    ),
                  ],
                ),
              )),
            )));
  }
}
