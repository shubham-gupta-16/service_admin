

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IntExt on int {
  String displayDate() {
    final DateFormat formatter = DateFormat('hh:mm a, dd MMM, yyyy');
    return formatter.format(DateTime.fromMicrosecondsSinceEpoch(this * 1000));
  }
}

extension StringExtNullable on String?{
  String? decode(){
    if (this == null) return null;
    return Uri.decodeFull(this!);
  }
  String? encode(){
    if (this == null) return null;
    return Uri.encodeFull(this!);
  }
}
extension StringExt on String{
  String decode(){
    return Uri.decodeFull(this);
  }
  String encode(){
    return Uri.encodeFull(this);
  }
}

extension Context on BuildContext {
  void navigatePush(Widget page){
    Navigator.push(this, MaterialPageRoute(builder: (context)=>page));
  }
  void navigatePushReplace(Widget page){
    Navigator.pushReplacement(this, MaterialPageRoute(builder: (context)=>page));
  }

  void navigatePop(){
    Navigator.pop(this);
  }

  showLoaderDialog(){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(),
          SizedBox(width: 7,),
          Text("Loading..." ),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:this,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}