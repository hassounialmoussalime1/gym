import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';

class CustomAppBarAdmin extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBarAdmin({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: AppColor.primary),
      ),
      title: Text(
        title,
        style: AppTextStyle.normalText.copyWith(
          color: AppColor.primary,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
