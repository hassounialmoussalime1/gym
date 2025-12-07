import 'package:flutter/material.dart';
import 'package:gym/core/navigation/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // خريطة العناوين مع المسارات
    final Map<String, String> menuRoutes = {
      'HOME': AppRoutes.home,
      'PRODUCT': AppRoutes.productScreen,
      'ABOUT US': AppRoutes.aboutScreen,
      'CONTACT': AppRoutes.contactsceen,
    };

    return Drawer(
      backgroundColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------- أيقونتين أعلى Drawer ---------
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.cartScreen);
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {
                    // ضع وظيفة أيقونة الثانية هنا
                  },
                  icon: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --------- روابط القائمة ---------
            ...menuRoutes.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(entry.value, (route) => false);
                  },
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
