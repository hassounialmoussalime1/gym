// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/core/tools/enums.dart';
import 'package:gym/data/models/order_model.dart';
import 'package:gym/features/admin/viewModel/admin_categorie_Controler.dart';
import 'package:gym/features/admin/viewModel/admin_order_controller.dart';
import 'package:gym/features/admin/viewModel/admin_product_controller.dart';
import 'package:gym/features/admin/widgets/admin_stat_card.dart';
import 'package:gym/features/admin/widgets/order_card.dart';
import 'package:gym/features/custommer/viewmodel/localization_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  late StreamSubscription ordersSubscription;
  @override
  void initState() {
    super.initState();

    // 🔥 وقت فتح الشاشة – نستخدمه لنعرف الطلبات الجديدة فقط
    final listenerStartTime = DateTime.now();

    // 🔹 تحديث الإحصائيات
    Provider.of<AdminOrderController>(context, listen: false).getOrderCount();
    Provider.of<AdminProductController>(
      context,
      listen: false,
    ).getProductCount();
    Provider.of<AdminCategorieController>(
      context,
      listen: false,
    ).getCategorieNb();

    // 🔥 Listener للطلبات الجديدة فقط
    ordersSubscription = collectionOrder
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>;


          if (data['dateSendOrder'] == null) continue;

          final orderTime = (data['dateSendOrder'] as Timestamp).toDate();

          if (orderTime.isAfter(listenerStartTime)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('New Order Received'),
                  content: Text('Order from: ${data['name']}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    ordersSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final flex = FlexibleSize(context);
    final adminOrderController = Provider.of<AdminOrderController>(context);
    final adminProductController = Provider.of<AdminProductController>(context);
    final adminCategorieController = Provider.of<AdminCategorieController>(
      context,
    );

    double width = MediaQuery.of(context).size.width;

    // بداية ونهاية اليوم
    final startOfDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final startTimestamp = Timestamp.fromDate(startOfDay);
    final endTimestamp = Timestamp.fromDate(endOfDay);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Admin POWERGEAR',
          style: AppTextStyle.normalText.copyWith(color: AppColor.primary),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
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
                          final provider = Provider.of<LocaleProvider>(context,
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
                          final provider = Provider.of<LocaleProvider>(context,
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
            ),
            icon: Icon(Icons.language, color: AppColor.primary),
          ),
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout, color: AppColor.primary),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.profileInfoScreen),
            icon: Icon(Icons.person_outline, color: AppColor.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: flex.height(0.02)),

            LayoutBuilder(
              builder: (context, constraints) {
                double width = MediaQuery.of(context).size.width;

                int crossAxisCount = 1;

                if (width < 600) {
                  // 📱 الهاتف → صفين كل صف فيه 2
                  crossAxisCount = 2;
                } else if (width < 900) {
                  crossAxisCount = 2;
                } else if (width < 1200) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 4;
                }

                return GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: width < 600 ? 1.1 : 1.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.orderScreenAd);
                      },
                      child: AdminStatCard(
                        icon: Icons.shopping_cart_outlined,
                        title: localise.orders,
                        value: '${adminOrderController.nbOrder}',
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.categorieScreenAd),
                      child: AdminStatCard(
                        icon: Icons.category,
                        title: localise.categories,
                        value: '${adminCategorieController.nbCategorie}',
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.adminProductScreen),
                      child: AdminStatCard(
                        icon: Icons.store_mall_directory_sharp,
                        title: localise.product,
                        value: '${adminProductController.productNb}',
                      ),
                    ),
                    AdminStatCard(
                      icon: Icons.person,
                      title: localise.users,
                      value: '-',
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: flex.height(0.02)),

            /// 🔹 TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  localise.newOrders,
                  style: AppTextStyle.normalTitle.copyWith(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 30),

            /// 🔹 ORDERS LIST — responsive width
            StreamBuilder<QuerySnapshot>(
              stream: collectionOrder
                  .where(
                    'dateSendOrder',
                    isGreaterThanOrEqualTo: startTimestamp,
                  )
                  .where('dateSendOrder', isLessThan: endTimestamp)
                  .orderBy('dateSendOrder', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final orders = snapshot.data!.docs;

                return Column(
                  children: orders.map((doc) {
                    final order = OrderModel.fromMap(
                      doc.data() as Map<String, dynamic>,
                    );
                    String date =
                        '${order.dateSendOrder?.day} - ${order.dateSendOrder?.month} - ${order.dateSendOrder!.year}';

                    return Container(
                      width: width > 600 ? width * 0.6 : width,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.orderDetailScreenAd,
                          arguments: order.id,
                        ),
                        child: OrderCard(
                          orderId: '${order.numberOrder}',
                          userName: order.name,
                          date: date,
                          status: statusOrderToString(order.status)!,
                          flex: flex,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: flex.height(0.020)),
          ],
        ),
      ),
    );
  }
}

void logout(BuildContext context) {
  html.window.localStorage.remove('adminToken');
  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
}
