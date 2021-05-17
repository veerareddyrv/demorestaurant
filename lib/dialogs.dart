import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

int navibarselectedindex = 0;

void toast(String message, bool color) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color == true ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

showLoaderDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(0.3),
        child: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
        )),
      );
    },
  );
}

Widget circularloader = Center(
    child: CircularProgressIndicator(
  backgroundColor: Colors.white,
  valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
));

bool online = true;

internetconnection(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(0.3),
        child: Center(child: Card(child: Text("check network connection"))),
      );
    },
  );
}
