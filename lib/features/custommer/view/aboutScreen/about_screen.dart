import 'package:flutter/material.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/componants/custom_app_bar.dart';
import 'package:gym/features/custommer/componants/custom_drawer.dart';
import 'package:gym/features/custommer/componants/custom_footer.dart';
import 'package:gym/features/custommer/componants/custom_hero_section.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  bool isAppBarBlack = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 250 && !isAppBarBlack) {
        setState(() => isAppBarBlack = true);
      } else if (_scrollController.offset <= 250 && isAppBarBlack) {
        setState(() => isAppBarBlack = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final localise = AppLocalizations.of(context)!;
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;

    double horizontalPadding = isMobile
        ? 20
        : isTablet
            ? 40
            : flex.width(0.15);

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: CustomDrawer(),
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ---------------- HERO IMAGE ----------------
                    CustomHeroSection(
                      title: localise.about,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(AppRoutes.home, (ctx) => false),
                      onTapMenu: () => _scaffoldKey.currentState!.openDrawer(),
                    ),

                    SizedBox(height: flex.height(0.04)),

                    // ---------------- CONTENT ----------------
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 1.2,
                            ),
                            children: [
                              _infoCard(
                                title: localise.WhoWeAre,
                                text: localise.WhoWeAreDes,
                              ),
                              _infoCard(
                                title: localise.OurMission,
                                text: localise.OurMissionDes,
                              ),
                              _infoCard(
                                title: localise.WhatWeOffer,
                                text: localise.WhatWeOfferDes,
                              ),
                              _infoCard(
                                title: localise.WhyChooseUs,
                                text: localise.WhyChooseUsDes,
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: isAppBarBlack ? Colors.black : Colors.transparent,
                  child: CustomAppBar(
                    onTapMenu: () => _scaffoldKey.currentState!.openDrawer(),
                    onChangeLanguage: () {},
                  ),
                ),
              ),
            ],
          )),
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
          // ignore: deprecated_member_use
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
