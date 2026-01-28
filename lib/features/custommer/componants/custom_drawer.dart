import 'package:flutter/material.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/viewmodel/localization_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context);
    // خريطة العناوين مع المسارات
    final Map<String, String> menuRoutes = {
      localise!.home: AppRoutes.home,
      localise.product: AppRoutes.productScreen,
      localise.about: AppRoutes.aboutScreen,
      localise.contact: AppRoutes.contactsceen,
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
                    Navigator.of(context).pushNamed(AppRoutes.authScreenAd);
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

            const Spacer(),
            const Divider(color: Colors.white54),

            // --------- زر تغيير اللغة ---------
            ListTile(
              leading: const Icon(Icons.language, color: Colors.white),
              title: Text(
                localise.changeLang,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                // مثال: تبديل بين العربية والإنجليزية
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(localise.selectLang),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              final provider = Provider.of<LocaleProvider>(
                                  context,
                                  listen: false);
                              provider.setLocale(const Locale('ar'));

                              Navigator.pop(context);
                            },
                            child: Text(
                              localise.arabic,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              final provider = Provider.of<LocaleProvider>(
                                  context,
                                  listen: false);
                              provider.setLocale(const Locale('en'));

                              Navigator.pop(context);
                            },
                            child: Text(
                              localise.english,
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
