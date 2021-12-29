import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DisplayMessage {
  static showSomethingWentWrong() {
    return Fluttertoast.showToast(
        msg: "Something went wrong", backgroundColor: Colors.red);
  }

  static showNotFound() {
    return Fluttertoast.showToast(
        msg: "Not Found", backgroundColor: Colors.red);
  }

  static showClassNotSelected() {
    return Fluttertoast.showToast(
        msg: "Please Select Class First", backgroundColor: Colors.red);
  }

  static showSubmitted() {
    return Fluttertoast.showToast(
        msg: "Attendance Submited", backgroundColor: Colors.red);
  }

  static showMsg(String msg) {
    return Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red);
  }
}
