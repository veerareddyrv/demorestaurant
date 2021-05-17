import 'package:badges/badges.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:demorestaurant/cart.dart';
import 'package:demorestaurant/dashboard.dart';
import 'package:demorestaurant/dialogs.dart';
import 'package:demorestaurant/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrdersState();
  }
}

bool ordersloader = true;
bool orders = false;
List ordersitems = [];

class OrdersState extends State {
  @override
  void initState() {
    super.initState();

    fetch();

    this.setState(() {
      navibarselectedindex = 2;
    });
  }

  Future<void> fetch() async {
    ordersitems.clear();
    var userid = FirebaseAuth.instance.currentUser.uid;
    print(userid);
    await FirebaseDatabase.instance
        .reference()
        .child("restaurant")
        .child("orders")
        .child(userid)
        .once()
        .then((DataSnapshot snapshot) => {
              map = snapshot.value,
              map.forEach((key, value) {
                this.setState(() {
                  ordersitems.add(value);
                });
              })
            })
        .catchError((e) => {print(e)});

    this.setState(() {
      ordersloader = false;
      if (ordersitems.length != 0) {
        orders = true;
      } else {
        orders = false;
      }
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
                title: Text("Orders"),
                backgroundColor: Colors.orange,
                elevation: 0,
              ),
              body: ordersloader == true
                  ? circularloader
                  : orders == false
                      ? Center(
                          child: Text("No orders"),
                        )
                      : SingleChildScrollView(
                          child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              for (int i = 0; i < ordersitems.length; i++)
                                (Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Card(
                                    color: Colors.grey[200],
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Image.asset("images/img.png"),
                                          width: 120,
                                        ),
                                        Container(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                              Text(" Name : " +
                                                  ordersitems[i]["name"]),
                                              Text(" Price : " +
                                                  ordersitems[i]["price"]
                                                      .toString()),
                                              Text(" Quantity : " +
                                                  ordersitems[i]["quantity"]
                                                      .toString()),
                                              Text(" Order Date : " +
                                                  ordersitems[i]["orderdate"]),
                                            ]))
                                      ],
                                    ),
                                  ),
                                )),
                            ],
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
