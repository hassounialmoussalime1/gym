import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/tools/open_instagram.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
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
                        InkWell(
                          onTap: () {
                            openInstagram();
                          },
                          child: contactItem(
                            flex,
                            Icons.phone_android,
                            true,
                            'Power_gear2',
                            isMobile: true,
                          ),
                        ),
                        contactItem(
                          flex,
                          Icons.location_on,
                          false,
                          'kuwait',
                        ),
                        contactItem(
                          flex,
                          Icons.email,
                          false,
                          'alummer60@gmail.com',
                        ),
                        contactItem(
                          flex,
                          Icons.phone_android,
                          false,
                          '+965 6632 4242',
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            openInstagram();
                          },
                          child: contactItem(
                            flex,
                            Icons.phone_android,
                            true,
                            'Power_gear2',
                            isMobile: false,
                          ),
                        ),
                        contactItem(
                          flex,
                          Icons.location_on,
                          false,
                          'kuweit',
                          isMobile: false,
                        ),
                        contactItem(
                          flex,
                          Icons.email,
                          false,
                          'alummer60@gmail.com',
                          isMobile: false,
                        ),
                        contactItem(
                          flex,
                          Icons.phone_android,
                          false,
                          '+965 6632 4242',
                          isMobile: false,
                        ),
                      ],
                    ),
              SizedBox(
                height: 20,
              ),
              // -------------------- COPYRIGHT --------------------
              Center(
                child: Text(
                  'Copyright ©2025 All rights reserved',
                  style: AppTextStyle.normalText.copyWith(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//
// ───────────────────────── CONTACT ITEM ─────────────────────────
//
Widget contactItem(
  FlexibleSize flex,
  IconData icon,
  bool isInstagram,
  String text, {
  bool isMobile = true,
}) {
  return Container(
    width: isMobile ? flex.screenWidth : flex.width(0.25),
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
          child: isInstagram
              ? Container(
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/icons/instagram.svg',
                    color: Colors.white,
                  ),
                )
              : Icon(icon, color: Colors.white, size: isMobile ? 22 : 30),
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
