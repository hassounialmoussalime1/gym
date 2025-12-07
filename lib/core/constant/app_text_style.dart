import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle largeTitle = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );
  static TextStyle normalTitle = TextStyle(fontSize: 25, color: Colors.white);
  static TextStyle normalText = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontFamily: 'sans-serif',
  );
  static TextStyle normalTextBold = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontFamily: 'sans-serif',
    fontWeight: FontWeight.w700,
  );
}
