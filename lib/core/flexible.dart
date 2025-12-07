import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class FlexibleSize {
  final BuildContext context;
  late double screenWidth;
  late double screenHeight;
  late DeviceType deviceType;

  FlexibleSize(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    // 👇 تحديد نوع الجهاز بناءً على العرض
    if (screenWidth >= 1000) {
      deviceType = DeviceType.desktop; // لابتوب
    } else if (screenWidth >= 600) {
      deviceType = DeviceType.tablet; // تابلت
    } else {
      deviceType = DeviceType.mobile; // هاتف
    }
  }

  // النسب حسب نوع الجهاز
  double width(double percent) {
    return screenWidth * _scale(percent);
  }

  double height(double percent) {
    return screenHeight * _scale(percent);
  }

  // footer ثابت
  double footerHeight() => screenHeight * 0.07;

  // padding
  double paddingHorizontal(double percent) {
    return screenWidth * _scale(percent);
  }

  double paddingVertical(double percent) {
    return screenHeight * _scale(percent);
  }

  // 👈 هنا السحر — تعديل النسب حسب نوع الجهاز
  double _scale(double percent) {
    switch (deviceType) {
      case DeviceType.mobile:
        return percent; // أصلي
      case DeviceType.tablet:
        return percent * 0.9; // شوي أصغر
      case DeviceType.desktop:
        return percent * 0.8; // أصغر أكثر
    }
  }
}
