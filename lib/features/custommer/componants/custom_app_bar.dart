import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/viewmodel/cart_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {super.key, required this.onTapMenu, required this.onChangeLanguage});
  final VoidCallback onTapMenu;
  final VoidCallback onChangeLanguage; // زر تغيير اللغة

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    final localise = AppLocalizations.of(context)!;
    final cartMv = Provider.of<CartController>(context);
    // خريطة العنوان -> Route
    final Map<String, String> menuRoutes = {
      localise.home: AppRoutes.home,
      localise.product: AppRoutes.productScreen,
      localise.about: AppRoutes.aboutScreen,
      localise.contact: AppRoutes.contactsceen,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        SizedBox(
          height: 70,
          width: 100,
          child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
        ),

        // MOBILE MENU
        if (isMobile)
          Row(
            children: [
              cartIcon(cartMv, context),
              SizedBox(width: flex.width(0.01)),
              IconButton(
                onPressed: onTapMenu,
                icon: Icon(Icons.menu, color: Colors.white, size: 30),
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
                        // ignore: use_build_context_synchronously
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
                  cartIcon(cartMv, context),
                  // زر تغيير اللغة للويب/تابلت
                  IconButton(
                    onPressed: onChangeLanguage,
                    icon: Icon(Icons.language, color: Colors.white, size: 22),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.authScreenAd);
                    },
                    icon: Icon(Icons.person_outline,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

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
            color: isHover ? AppColor.primary : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Widget cartIcon(CartController cartMv, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).pushNamed(AppRoutes.cartScreen);
    },
    child: Stack(children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          Icons.shopping_cart_outlined,
          color: AppColor.primary,
          size: 28,
        ),
      ),
      cartMv.cartItems.isNotEmpty
          ? Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 255, 20, 3)),
                child: Text(
                  cartMv.cartItems.length.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ))
          : SizedBox()
    ]),
  );
}
