import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/l10n/app_localizations.dart';

class CustomHeroSection extends StatelessWidget {
  final String title;
  final Function onTapMenu;
  final Function onTap;
  const CustomHeroSection({
    super.key,
    required this.title,
    required this.onTap,
    required this.onTapMenu,
  });

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
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
                // ignore: deprecated_member_use
                colors: [Colors.black, Colors.black.withOpacity(0.4)],
                stops: [0.0, 1],
              ),
            ),
          ),
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
                      '${localise.home}  >',
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
