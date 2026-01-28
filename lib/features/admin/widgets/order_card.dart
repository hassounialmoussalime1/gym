import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/l10n/app_localizations.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String userName;
  final String date;
  final String status;
  final FlexibleSize flex;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.userName,
    required this.date,
    required this.status,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    return Card(
      // ignore: deprecated_member_use
      color: AppColor.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ORDER HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${localise.orderId} #$orderId',
                  style: AppTextStyle.normalText.copyWith(fontSize: 16),
                ),
                Container(
                  width: flex.width(0.25),
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyle.normalText.copyWith(fontSize: 15),
                  ),
                ),
              ],
            ),

            SizedBox(height: flex.height(0.01)),

            /// USER
            Row(
              children: [
                Icon(Icons.person_outline, color: AppColor.primary, size: 15),
                const SizedBox(width: 10),
                Text(
                  userName,
                  style: AppTextStyle.normalText.copyWith(
                    fontSize: 13,
                    color: const Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ],
            ),

            SizedBox(height: flex.height(0.01)),

            /// DATE
            Row(
              children: [
                Icon(Icons.date_range, color: AppColor.primary, size: 15),
                const SizedBox(width: 10),
                Text(
                  '${localise.date}: $date',
                  style: AppTextStyle.normalText.copyWith(
                    fontSize: 13,
                    color: const Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
