import 'package:flutter/material.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/view/componants/custom_footer.dart';
import 'package:gym/view/componants/custom_hero_section.dart';
import 'package:gym/core/constant/app_color.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;

    double horizontalPadding = isMobile
        ? 20
        : isTablet
        ? 40
        : flex.width(0.15);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------- HERO IMAGE ----------------
              CustomHeroSection(
                title: 'About Us',
                onTap: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (ctx) => false),
              ),

              SizedBox(height: flex.height(0.04)),

              // ---------------- CONTENT ----------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 1; // Mobile

                    if (constraints.maxWidth >= 1200) {
                      crossAxisCount = 2; // Desktop
                    } else if (constraints.maxWidth >= 700) {
                      crossAxisCount = 2; // Tablet
                    }

                    return GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.5,
                      ),
                      children: [
                        _infoCard(
                          title: "Who We Are",
                          text:
                              "We are a specialized team offering premium supplements, training gear, and everything you need for a healthier lifestyle.",
                        ),
                        _infoCard(
                          title: "Our Mission",
                          text:
                              "Delivering 100% authentic products, best prices, fast shipping, and top-level customer support.",
                        ),
                        _infoCard(
                          title: "What We Offer",
                          text:
                              "• Whey Protein\n• Mass Gainers\n• Creatine & BCAA\n• Vitamins\n• Gym equipment\n• Fitness apparel",
                        ),
                        _infoCard(
                          title: "Why Choose Us",
                          text:
                              "✔ Original products\n✔ Fast delivery\n✔ Best prices\n✔ 24/7 support\n✔ Easy return policy",
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: flex.height(0.040)),
              CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _infoCard({required String title, required String text}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColor.primary, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: AppColor.primary.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
