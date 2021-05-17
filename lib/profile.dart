import 'package:badges/badges.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:demorestaurant/cart.dart';
import 'package:demorestaurant/dashboard.dart';
import 'package:demorestaurant/dialogs.dart';
import 'package:demorestaurant/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

String name = "", email = "", phone = "";
bool profileloader = true;

class ProfileState extends State {
  @override
  void initState() {
    super.initState();
    fetch();
    cartnum();
    this.setState(() {
      navibarselectedindex = 3;
    });
  }

  Future<void> cartnum() async {
    cartcount = 0;
    var userid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseDatabase.instance
        .reference()
        .child("restaurant")
        .child("cart")
        .child(userid)
        .once()
        .then((DataSnapshot snapshot) => {
              map = snapshot.value,
              map.forEach((key, value) {
                this.setState(() {
                  cartcount++;
                });
              })
            });
  }

  Future<void> fetch() async {
    var userid = FirebaseAuth.instance.currentUser.uid;
    print(userid);
    await FirebaseDatabase.instance
        .reference()
        .child("restaurant")
        .child("users")
        .child(userid)
        .once()
        .then((DataSnapshot snapshot) => {
              this.setState(() {
                print(snapshot.value);
                name = snapshot.value["name"];
                email = snapshot.value["email"];
                phone = snapshot.value["phone"];
              })
            })
        .catchError((e) => {print(e)});

    this.setState(() {
      profileloader = false;
    });
  }

  Future<bool> backPressed() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: backPressed,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
                title: Text("Profile"),
                backgroundColor: Colors.orange,
                elevation: 0,
              ),
              body: profileloader == true
                  ? circularloader
                  : SingleChildScrollView(
                      child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.orange[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Name : " + name,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Email : " + email,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Phone : " + phone,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              bottomNavigationBar: BottomNavyBar(
                backgroundColor: Colors.orange[200],
                selectedIndex: navibarselectedindex,
                curve: Curves.easeIn,
                onItemSelected: (index) => setState(() {
                  navibarselectedindex = index;
                  if (index == 0) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  } else if (index == 1) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  } else if (index == 2) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Orders()));
                  } else if (index == 3) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  }
                }),
                items: [
                  BottomNavyBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Home'),
                    activeColor: Colors.red,
                  ),
                  BottomNavyBarItem(
                      icon: Badge(
                        badgeContent: Text(cartcount.toString()),
                        badgeColor: Colors.white,
                        child: Icon(Icons.shopping_bag),
                      ),
                      title: Text("Cart"),
                      activeColor: Colors.purpleAccent),
                  BottomNavyBarItem(
                      icon: Icon(Icons.book),
                      title: Text('My Orders'),
                      activeColor: Colors.pink),
                  BottomNavyBarItem(
                      icon: Icon(Icons.person),
                      title: Text('Profile'),
                      activeColor: Colors.blue),
                ],
              )),
        ));
  }
}
