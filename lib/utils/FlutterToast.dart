import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message {
  static void show({
    String msg = "Book Added Successfully",
    Toast? toastLength = Toast.LENGTH_SHORT,
    ToastGravity? gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 1,
    Color? backgroundColor = Colors.green,
    Color? textColor = Colors.white,
    double? fontSize = 18,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
