import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';

class CustomSearch extends StatefulWidget {
  const CustomSearch({super.key});

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: flex.screenWidth > 580 ? flex.width(0.5) : flex.screenWidth,
      height: flex.height(0.070),
      child: TextField(
        textAlign: TextAlign.center, // 👈 يجعل النص و الـ hint بالنص
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          hintText: 'search here !!',
          hintStyle: AppTextStyle.normalText.copyWith(
            color: AppColor.primary.withOpacity(0.7),
          ),

          // 👈 مهم جداً: استخدم prefixIcon وليس prefix
          prefixIcon: Icon(Icons.search, color: AppColor.primary),

          contentPadding: EdgeInsets.all(5),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
