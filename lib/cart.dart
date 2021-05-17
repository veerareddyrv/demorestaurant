import 'package:badges/badges.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:demorestaurant/dashboard.dart';
import 'package:demorestaurant/dialogs.dart';
import 'package:demorestaurant/orders.dart';
import 'package:demorestaurant/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

bool cartloader = true;
bool checkout = false;
List cartitems = [];

class CartState extends State {
  @override
  void initState() {
    super.initState();
    fetch();
    cartnum();
    this.setState(() {
      navibarselectedindex = 1;
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
    cartitems.clear();
    var userid = FirebaseAuth.instance.currentUser.uid;
    print(userid);
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
                  cartitems.add(value);
                });
              })
            })
        .catchError((e) => {print(e)});

    this.setState(() {
      cartloader = false;
      if (cartitems.length != 0) {
        checkout = true;
      } else {
        checkout = false;
      }
    });
  }

  Future<void> sendtoorders() async {
    print(cartitems.length);
    for (int i = 0; i < cartitems.length; i++) {
      await FirebaseDatabase.instance
          .reference()
          .child("restaurant")
          .child("orders")
          .child(FirebaseAuth.instance.currentUser.uid)
          .push()
          .set({
        "name": cartitems[i]["name"],
        "price": cartitems[i]["price"],
        "quantity": cartitems[i]["quantity"],
        "orderdate": DateFormat("dd-MM-yyyy").format(DateTime.now()).toString()
      }).then((value) => {});
    }
  }

  Future<void> removefromcart() async {
    await FirebaseDatabase.instance
        .reference()
        .child("restaurant")
        .child("cart")
        .child(FirebaseAuth.instance.currentUser.uid)
        .remove()
        .then((value) => {});
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
                title: Text("Cart"),
                backgroundColor: Colors.orange,
                elevation: 0,
              ),
              body: cartloader == true
                  ? circularloader
                  : checkout == false
                      ? Center(
                          child: Text("No items in cart"),
                        )
                      : SingleChildScrollView(
                          child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              for (int i = 0; i < cartitems.length; i++)
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
                                                cartitems[i]["name"]),
                                            Text(" Price : " +
                                                cartitems[i]["price"]
                                                    .toString()),
                                            Divider(
                                              color: Colors.orange,
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      await FirebaseDatabase
                                                          .instance
                                                          .reference()
                                                          .child("restaurant")
                                                          .child("cart")
                                                          .child(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .uid)
                                                          .child(cartitems[i]
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
                                                                        .instance
                                                                        .currentUser
                                                                        .uid)
                                                                    .child(cartitems[
                                                                            i]
                                                                        ["id"])
                                                                    .remove()
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              toast("product removed from cart", false),
                                                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Cart()))
                                                                            })
                                                                    .catchError(
                                                                        (e) => {
                                                                              toast(e.toString(), false)
                                                                            })
                                                              });
                                                    }),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      if (cartitems[i]
                                                              ["quantity"] >
                                                          1) {
                                                        await FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child("restaurant")
                                                            .child("cart")
                                                            .child(FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .uid)
                                                            .child(cartitems[i]
                                                                ["id"])
                                                            .update({
                                                              "quantity":
                                                                  cartitems[i][
                                                                          "quantity"] -
                                                                      1
                                                            })
                                                            .then((value) => {
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Cart()))
                                                                })
                                                            .catchError((e) {
                                                              toast(
                                                                  e.toString(),
                                                                  false);
                                                            });
                                                      }
                                                    }),
                                                Text(" " +
                                                    cartitems[i]["quantity"]
                                                        .toString() +
                                                    " "),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () async {
                                                      await FirebaseDatabase
                                                          .instance
                                                          .reference()
                                                          .child("restaurant")
                                                          .child("cart")
                                                          .child(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .uid)
                                                          .child(cartitems[i]
                                                              ["id"])
                                                          .update({
                                                            "quantity": cartitems[
                                                                        i][
                                                                    "quantity"] +
                                                                1
                                                          })
                                                          .then((value) => {
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Cart()))
                                                              })
                                                          .catchError((e) {
                                                            toast(e.toString(),
                                                                false);
                                                          });
                                                    }),
                                              ],
                                            )
                                          ],
                                        )),
                                        Divider(
                                          color: Colors.orange,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                              Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                child: checkout == true
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green[500]),
                                        onPressed: () {
                                          sendtoorders().whenComplete(() => {
                                                removefromcart()
                                                    .whenComplete(() => {
                                                          toast(
                                                              "Order placed Successfully",
                                                              true),
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Cart()))
                                                        })
                                              });
                                        },
                                        child: Text("Proceed to checkout"))
                                    : Container(),
                              )
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
                      title: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Cart")),
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
