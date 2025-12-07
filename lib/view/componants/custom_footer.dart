import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;
    final isDesktop = !isMobile && !isTablet;

    return Container(
      width: flex.screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: flex.width(0.050),
        vertical: flex.width(0.020),
      ),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------- CONTACT SECTION --------------------
          isMobile
              ? Column(
                  children: [
                    contactItem(
                      flex,
                      Icons.location_on,
                      '333 Middle Winchendon Rd, Rindge,NH 03461',
                    ),
                    contactItem(
                      flex,
                      Icons.email,
                      'Support.gymcenter@gmail.com',
                    ),
                    contactItem(
                      flex,
                      Icons.phone_android,
                      '125-711-811  125-668-886',
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    contactItem(
                      flex,
                      Icons.location_on,
                      '333 Middle Winchendon Rd, Rindge,NH 03461',
                      isMobile: false,
                    ),
                    contactItem(
                      flex,
                      Icons.email,
                      'Support.gymcenter@gmail.com',
                      isMobile: false,
                    ),
                    contactItem(
                      flex,
                      Icons.phone_android,
                      '125-711-811 125-668-886',
                      isMobile: false,
                    ),
                  ],
                ),

          SizedBox(height: flex.height(0.05)),

          Divider(color: Colors.white24, height: 1),

          SizedBox(height: flex.height(0.05)),

          // -------------------- MAIN FOOTER CONTENT --------------------
          isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    footerAbout(flex, isMobile),
                    footerLinks(flex, isMobile),
                    footerTips(flex, isMobile),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    footerAbout(flex, isMobile),
                    SizedBox(height: 30),
                    footerLinks(flex, isMobile),
                    SizedBox(height: 30),
                    footerTips(flex, isMobile),
                  ],
                ),

          SizedBox(height: flex.height(0.05)),

          // -------------------- COPYRIGHT --------------------
          Center(
            child: Text(
              'Copyright ©2025 All rights reserved',
              style: AppTextStyle.normalText.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ───────────────────────── CONTACT ITEM ─────────────────────────
//
Widget contactItem(
  FlexibleSize flex,
  IconData icon,
  String text, {
  bool isMobile = true,
}) {
  return Container(
    width: isMobile ? flex.screenWidth : flex.width(0.30),
    margin: EdgeInsets.only(bottom: isMobile ? 20 : 0),
    child: Row(
      children: [
        Container(
          width: isMobile ? 45 : 60,
          height: isMobile ? 45 : 60,
          decoration: BoxDecoration(
            color: AppColor.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: isMobile ? 22 : 30),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.normalText.copyWith(
              color: Colors.grey[300],
              fontSize: isMobile ? 13 : 15,
            ),
          ),
        ),
      ],
    ),
  );
}

//
// ───────────────────────── ABOUT SECTION ─────────────────────────
//
Widget footerAbout(FlexibleSize flex, bool isMobil) {
  return Container(
    width: isMobil ? flex.screenWidth : flex.width(0.30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('GY', style: AppTextStyle.largeTitle),
            Text(
              'M',
              style: AppTextStyle.largeTitle.copyWith(color: AppColor.primary),
            ),
          ],
        ),
        SizedBox(height: flex.height(0.030)),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore dolore magna aliqua.',
          style: AppTextStyle.normalText.copyWith(color: Colors.grey),
        ),
      ],
    ),
  );
}

//
// ───────────────────────── LINKS SECTION ─────────────────────────
//
Widget footerLinks(FlexibleSize flex, bool isMobile) {
  return Container(
    width: isMobile ? flex.screenWidth : flex.width(0.30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        footerLinksColumn('Useful Links'),
        footerLinksColumn('Support'),
      ],
    ),
  );
}

Widget footerLinksColumn(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTextStyle.normalTitle),
      SizedBox(height: 10),
      footerLinkItem(),
      footerLinkItem(),
      footerLinkItem(),
      footerLinkItem(),
    ],
  );
}

Widget footerLinkItem() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      'About',
      style: AppTextStyle.normalText.copyWith(color: Colors.grey),
    ),
  );
}

//
// ───────────────────────── TIPS SECTION ─────────────────────────
//
Widget footerTips(FlexibleSize flex, bool isMobile) {
  return Container(
    width: isMobile ? flex.screenWidth : flex.width(0.30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tips & Guides', style: AppTextStyle.normalTitle),
        SizedBox(height: 10),
        tipItem(),
        SizedBox(height: 10),
        tipItem(),
      ],
    ),
  );
}

Widget tipItem() {
  return Text(
    'Physical fitness may help prevent depression, anxiety',
    style: AppTextStyle.normalText.copyWith(
      color: Colors.grey,
      fontSize: 12,
      fontFamily: 'FjallaOne',
    ),
  );
}
