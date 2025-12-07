import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/view/componants/custom_app_bar.dart';

class CustomHeroSection extends StatelessWidget {
  final String title;
  final Function onTap;
  const CustomHeroSection({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;
    return SizedBox(
      width: flex.screenWidth,
      height: isMobile
          ? flex.height(0.4)
          : isTablet
          ? flex.height(0.35)
          : flex.height(0.98),
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Image.asset(
            'assets/images/herosection2.webp',
            fit: BoxFit.cover,
            width: flex.screenWidth,
            height: flex.screenHeight,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.black, Colors.black.withOpacity(0.4)],
                stops: [0.0, 1],
              ),
            ),
          ),

          _buildHeaderMenu(flex, isMobile),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: AppTextStyle.largeTitle),
              SizedBox(height: flex.height(0.050)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => onTap(),
                    child: Text(
                      'home  >',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Text(
                    ' $title',
                    style: TextStyle(fontSize: 15, color: AppColor.primary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildHeaderMenu(FlexibleSize flex, bool isMobile) {
  return Positioned(
    top: 20,
    left: 20,
    right: 20,
    child: CustomAppBar(onTapMenu: () => {}),
  );
}
