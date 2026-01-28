import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';

class AdminStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const AdminStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);

    return SizedBox(
      width: flex.width(0.4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // ignore: deprecated_member_use
        color: AppColor.primary.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Colors.white),
              SizedBox(height: flex.height(0.01)),
              Text(title, style: AppTextStyle.normalText),
              SizedBox(height: flex.height(0.02)),
              Container(
                width: 60,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(value, style: AppTextStyle.normalText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
