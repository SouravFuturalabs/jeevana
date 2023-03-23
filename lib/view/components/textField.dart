import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class TextFieldLogin extends StatelessWidget {
  String hinttext;
  bool obscured;
  bool? enabled;
  final icon;
  final Controller;
  final OnChange;
  final OnTap;
  TextFieldLogin({Key? key,required this.hinttext,required this.obscured,required this.icon, this.enabled,required this.Controller,required this.OnChange,required this.OnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      // padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(width: 1.5,color: Colors.grey)
      ),
      child:
      TextField(
        controller: Controller,
        obscureText: obscured,
        onChanged: OnChange,
        onTap: OnTap,
        enabled: enabled,
        decoration:  InputDecoration(
            prefixIcon: icon,
            prefixIconColor: Colors.redAccent,
            border: InputBorder.none,
            hintText:hinttext ,
            hintStyle: TextStyle(fontSize: 16)
        ),
      ),
    );
  }
}