import 'package:badges/badges.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demorestaurant/cart.dart';
import 'package:demorestaurant/dialogs.dart';
import 'package:demorestaurant/orders.dart';
import 'package:demorestaurant/profile.dart';
import 'package:demorestaurant/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List menu = [];
int cartcount = 0;
Map<dynamic, dynamic> map;
bool dashboardloader = true;

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State {
  @override
  void initState() {
    super.initState();

    fetch();
    cartnum();
    this.setState(() {
      navibarselectedindex = 0;
    });
  }

  Future<void> fetch() async {
    menu.clear();

    await FirebaseDatabase.instance
        .reference()
        .child("restaurant")
        .child("menu")
        .once()
        .then((DataSnapshot snapshot) => {
              map = snapshot.value,
              map.forEach((key, value) async {
                await FirebaseDatabase.instance
                    .reference()
                    .child("restaurant")
                    .child("menu")
                    .child(key)
                    .once()
                    .then((DataSnapshot snapshot) => {
                          map = snapshot.value,
                          map.forEach((key, value) {
                            this.setState(() {
                              menu.add(value);
                            });
                          })
                        });
              })
            });

    this.setState(() {
      dashboardloader = false;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text("Dashboard"),
              backgroundColor: Colors.orange,
              elevation: 0,
              actions: [
                IconButton(
                    icon: Icon(Icons.logout),
                    color: Colors.white,
                    onPressed: () async {
                      FirebaseAuth.instance
                          .signOut()
                          .then((value) => {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()))
                              })
                          .catchError((e) {
                        toast(e.toString(), false);
                      });
                    })
              ],
            ),
            body: dashboardloader == true
                ? circularloader
                : SingleChildScrollView(
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
                            Center(
                                child: CarouselSlider(
                              options: CarouselOptions(
                                height: 180.0,
                              ),
                              items: [
                                "images/image.png",
                                "images/img.png",
                                "images/chicken.png",
                                "images/samosa.png",
                                "images/pizza.png"
                              ].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(i)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    );
                                  },
                                );
                              }).toList(),
                            )),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Center(
                          child: Text(
                            "Menu Items",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        for (int i = 0; i < menu.length; i++)
                          (Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.grey[200],
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.asset("images/img.png"),
                                    width: 100,
                                    height: 100,
                                  ),
                                  Container(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Name : " + menu[i]["name"]),
                                      Text("Price : " +
                                          menu[i]["price"].toString()),
                                      Divider(
                                        color: Colors.orange,
                                      ),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green[500]),
                                              onPressed: () async {
                                                await FirebaseDatabase.instance
                                                    .reference()
                                                    .child("restaurant")
                                                    .child("cart")
                                                    .child(FirebaseAuth.instance
                                                        .currentUser.uid)
                                                    .child(menu[i]["id"])
                                                    .once()
                                                    .then((DataSnapshot
                                                            snapshot) async =>
                                                        {
                                                          if (snapshot.value ==
                                                              null)
                                                            {
                                                              await FirebaseDatabase
                                                                  .instance
                                                                  .reference()
                                                                  .child(
                                                                      "restaurant")
                                                                  .child("cart")
                                                                  .child(FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .uid)
                                                                  .child(menu[i]
                                                                      ["id"])
                                                                  .set({
                                                                    "id": menu[
                                                                            i]
                                                                        ["id"],
                                                                    "name": menu[
                                                                            i][
                                                                        "name"],
                                                                    "price": menu[
                                                                            i][
                                                                        "price"],
                                                                    "quantity":
                                                                        1
                                                                  })
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            toast("product added to cart",
                                                                                true),
                                                                            cartnum()
                                                                          })
                                                                  .catchError(
                                                                      (e) => {
                                                                            toast(e.toString(),
                                                                                false)
                                                                          })
                                                            }
                                                          else
                                                            {
                                                              await FirebaseDatabase
                                                                  .instance
                                                                  .reference()
                                                                  .child(
                                                                      "restaurant")
                                                                  .child("cart")
                                                                  .child(FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .uid)
                                                                  .child(menu[i]
                                                                      ["id"])
                                                                  .once()
                                                                  .then((DataSnapshot
                                                                          snapshot) async =>
                                                                      {
                                                                        await FirebaseDatabase
                                                                            .instance
                                                                            .reference()
                                                                            .child(
                                                                                "restaurant")
                                                                            .child(
                                                                                "cart")
                                                                            .child(FirebaseAuth
                                                                                .instance.currentUser.uid)
                                                                            .child(menu[i][
                                                                                "id"])
                                                                            .update({
                                                                              "quantity": snapshot.value["quantity"] + 1
                                                                            })
                                                                            .then((value) =>
                                                                                {
                                                                                  toast("product added to cart", true),
                                                                                  cartnum()
                                                                                })
                                                                            .catchError((e) =>
                                                                                {
                                                                                  toast(e.toString(), false)
                                                                                })
                                                                      }),
                                                            }
                                                        })
                                                    .catchError((e) {
                                                  toast(e.toString(), false);
                                                });
                                              },
                                              child: Text("Add To Cart")))
                                    ],
                                  )),
                                  Divider(
                                    color: Colors.orange,
                                  )
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
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Cart()));
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
            )));
  }
}
