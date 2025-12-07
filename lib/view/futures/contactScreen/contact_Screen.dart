// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/view/componants/custom_footer.dart';
import 'package:gym/view/componants/custom_hero_section.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;

    double horizontalPadding = isMobile
        ? 20
        : isTablet
        ? 40
        : flex.width(0.1);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------- HERO IMAGE ----------------
              CustomHeroSection(
                title: 'Contact Us',
                onTap: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (ctx) => false),
              ),

              SizedBox(height: flex.height(0.04)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                                      title: "Phone",
                                      text: "+123 456 7890",
                                    ),
                                    SizedBox(height: flex.height(0.020)),
                                    _contactCard(
                                      icon: Icons.email_outlined,
                                      title: "Email",
                                      text: "support@gymstore.com",
                                    ),
                                    SizedBox(height: flex.height(0.020)),
                                    _contactCard(
                                      icon: Icons.location_on_outlined,
                                      title: "Location",
                                      text: "Street 12, Fitness City, USA",
                                    ),
                                    SizedBox(height: flex.height(0.020)),
                                    _contactCard(
                                      icon: Icons.access_time,
                                      title: "Working Hours",
                                      text: "Mon – Fri: 9 AM to 6 PM",
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 40),

                              // RIGHT — FORM
                              SizedBox(
                                width: flex.screenWidth,
                                child: _buildForm(isMobile),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      title: "Phone",
                                      text: "+123 456 7890",
                                    ),
                                    SizedBox(height: flex.height(0.020)),
                                    _contactCard(
                                      icon: Icons.email_outlined,
                                      title: "Email",
                                      text: "support@gymstore.com",
                                    ),
                                    SizedBox(height: flex.height(0.020)),
                                    _contactCard(
                                      icon: Icons.location_on_outlined,
                                      title: "Location",
                                      text: "Street 12, Fitness City, USA",
                                    ),
                                    SizedBox(height: flex.height(0.020)),
                                    _contactCard(
                                      icon: Icons.access_time,
                                      title: "Working Hours",
                                      text: "Mon – Fri: 9 AM to 6 PM",
                                    ),
                                  ],
                                ),
                              ),

                              // RIGHT — FORM
                              SizedBox(
                                width: flex.width(0.5),
                                child: _buildForm(isMobile),
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
      ),
    );
  }
}

Widget _buildForm(bool isMobile) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Send Us a Message",
        style: TextStyle(
          fontSize: isMobile ? 22 : 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 20),

      _inputField(label: "Full Name"),
      SizedBox(height: 20),

      _inputField(label: "Email Address"),
      SizedBox(height: 20),

      _inputField(label: "Message", maxLines: 5),
      SizedBox(height: 20),

      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrangeAccent,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        ),
        onPressed: () {},
        child: Text(
          "Send Message",
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
