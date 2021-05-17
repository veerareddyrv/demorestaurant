import 'dart:async';
import 'dart:ui';
import 'package:demorestaurant/dashboard.dart';
import 'package:demorestaurant/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
  }
}

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State {
  void initState() {
    super.initState();
    Future<void> validationdata() async {
      SharedPreferences logindetails = await SharedPreferences.getInstance();
      String uid = logindetails.getString("uid");

      if (uid != null) {
        Timer(Duration(seconds: 5), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        });
      } else {
        Timer(Duration(seconds: 5), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        });
      }
    }

    validationdata();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.orange,
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(
                              child: CircleAvatar(
                            backgroundImage: AssetImage("images/image.png"),
                            radius: 90,
                          ))),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(
                            "RESTAURANT",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: Column(
                          children: [
                            Text("Welcome to Demo Restaurant"),
                            Padding(padding: EdgeInsets.only(top: 50)),
                            Container(
                              width: 50,
                              height: 50,
                              child: Card(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.orange),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
