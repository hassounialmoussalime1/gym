// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/componants/custom_app_bar.dart';
import 'package:gym/features/custommer/componants/custom_drawer.dart';
import 'package:gym/features/custommer/componants/custom_footer.dart';
import 'package:gym/features/custommer/componants/custom_hero_section.dart';
import 'package:gym/l10n/app_localizations.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;
    final localise = AppLocalizations.of(context)!;
    double horizontalPadding = isMobile
        ? 20
        : isTablet
            ? 40
            : flex.width(0.1);

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
                      title: localise.contact,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(AppRoutes.home, (ctx) => false),
                      onTapMenu: () => _scaffoldKey.currentState!.openDrawer(),
                    ),

                    SizedBox(height: flex.height(0.04)),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          isMobile
                              ? Column(
                                  children: [
                                    // LEFT — CARDS
                                    SizedBox(
                                      width: flex.screenWidth,
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          _contactCard(
                                            icon: Icons.phone,
                                            title: localise.phone,
                                            text: "+965 6632 4242",
                                          ),
                                          SizedBox(height: flex.height(0.020)),
                                          _contactCard(
                                            icon: Icons.email_outlined,
                                            title: localise.email,
                                            text: "alummer60@gmail.com",
                                          ),
                                          SizedBox(height: flex.height(0.020)),
                                          _contactCard(
                                            icon: Icons.location_on_outlined,
                                            title: localise.location,
                                            text: "kweit",
                                          ),
                                          SizedBox(height: flex.height(0.020)),
                                          _contactCard(
                                            icon: Icons.access_time,
                                            title: localise.workingHour,
                                            text: "Mon – Fri: 9 AM to 6 PM",
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 40),

                                    // RIGHT — FORM
                                    SizedBox(
                                      width: flex.screenWidth,
                                      child: _buildForm(isMobile, context),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // LEFT — CARDS
                                    SizedBox(
                                      width: flex.width(0.4),
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          _contactCard(
                                            icon: Icons.phone,
                                            title: localise.phone,
                                            text: "+965 6632 4242",
                                          ),
                                          SizedBox(height: flex.height(0.020)),
                                          _contactCard(
                                            icon: Icons.email_outlined,
                                            title: localise.email,
                                            text: "alummer60@gmail.com",
                                          ),
                                          SizedBox(height: flex.height(0.020)),
                                          _contactCard(
                                            icon: Icons.location_on_outlined,
                                            title: localise.location,
                                            text: "kweit",
                                          ),
                                          SizedBox(height: flex.height(0.020)),
                                          _contactCard(
                                            icon: Icons.access_time,
                                            title: localise.workingHour,
                                            text: "Mon – Fri: 9 AM to 6 PM",
                                          ),
                                        ],
                                      ),
                                    ),

                                    // RIGHT — FORM
                                    SizedBox(
                                      width: flex.width(0.5),
                                      child: _buildForm(isMobile, context),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
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
                  color: isAppBarBlack ? Colors.black : Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 10),
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

Widget _buildForm(bool isMobile, BuildContext context) {
  final localise = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        localise.sendMessage,
        style: TextStyle(
          fontSize: isMobile ? 22 : 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 20),
      _inputField(label: localise.fullNamw),
      SizedBox(height: 20),
      _inputField(label: localise.email),
      SizedBox(height: 20),
      _inputField(label: localise.Message, maxLines: 5),
      SizedBox(height: 20),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        ),
        onPressed: () {},
        child: Text(
          localise.sendMessag,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    ],
  );
}

// ignore: camel_case_types
class _contactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _contactCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    return Container(
      padding: const EdgeInsets.all(20),
      width: isMobile ? flex.screenWidth : flex.width(0.4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.primary, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: AppColor.primary),
          SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                text,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _inputField({required String label, int maxLines = 1}) {
  return TextField(
    maxLines: maxLines,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
    ),
  );
}
