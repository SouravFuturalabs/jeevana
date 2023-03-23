
import 'package:flutter/material.dart';

class SampleTextStyle extends TextStyle {
  @override
  double? get fontSize => 22;
  FontWeight? get fontWeight => FontWeight.w500;
}
class SampleTextStyle2 extends TextStyle {
  @override
  double? get fontSize => 14;
  FontWeight? get fontWeight => FontWeight.w500;
  Color? get color => Colors.white;
}
class MySizedBox extends SizedBox{
  @override
  // TODO: implement height
  double? get height => 10;
}
class BaseURL {
  String baseUrl = 'https://jeevana.projectsvn.com';
}