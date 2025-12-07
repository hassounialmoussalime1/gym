import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.onTapMenu});
  final VoidCallback onTapMenu;

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;

    // خريطة العنوان -> Route
    final Map<String, String> menuRoutes = {
      'HOME': AppRoutes.home,
      'PRODUCT': AppRoutes.productScreen,
      'ABOUT US': AppRoutes.aboutScreen,
      'Contact US': AppRoutes.contactsceen,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Row(
          children: [
            Text('GY', style: AppTextStyle.largeTitle),
            Text(
              'M',
              style: AppTextStyle.largeTitle.copyWith(color: AppColor.primary),
            ),
          ],
        ),

        // MOBILE MENU
        if (isMobile)
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.cartScreen);
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColor.primary,
                  size: 35,
                ),
              ),
              SizedBox(width: flex.width(0.01)),
              IconButton(
                onPressed: onTapMenu, // بدون الأقواس
                icon: Icon(Icons.menu, color: Colors.white, size: 35),
              ),
            ],
          ),

        // WEB / TABLET MENU
        if (!isMobile)
          Row(
            children: [
              Row(
                children: menuRoutes.entries.map((entry) {
                  return InkWell(
                    onTap: () {
                      Future.microtask(() {
                        Navigator.of(context).pushNamed(entry.value);
                      });
                    },
                    child: HoverMenuItem(title: entry.key),
                  );
                }).toList(),
              ),
              SizedBox(width: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search, color: Colors.white, size: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.cartScreen);
                    },
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

// ---------------------- HOVER MENU ITEM ----------------------
class HoverMenuItem extends StatefulWidget {
  final String title;
  const HoverMenuItem({required this.title, super.key});

  @override
  State<HoverMenuItem> createState() => _HoverMenuItemState();
}

class _HoverMenuItemState extends State<HoverMenuItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            color: isHover ? Colors.deepOrangeAccent : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
