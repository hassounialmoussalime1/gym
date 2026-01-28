import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';

class Circleindicator extends StatelessWidget {
  const Circleindicator({super.key});

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    return SizedBox(
      width: flex.screenWidth,
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColor.primary,
        ),
      ),
    );
  }
}
