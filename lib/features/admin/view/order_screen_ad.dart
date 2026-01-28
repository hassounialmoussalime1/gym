import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/core/tools/enums.dart';
import 'package:gym/data/models/order_model.dart';
import 'package:gym/features/admin/widgets/order_card.dart';

class OrderScreenAd extends StatefulWidget {
  const OrderScreenAd({super.key});

  @override
  State<OrderScreenAd> createState() => _OrderScreenAdState();
}

class _OrderScreenAdState extends State<OrderScreenAd> {
  StatusOrder selectedStatus = StatusOrder.newOrder;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);


    final startOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final startTimestamp = Timestamp.fromDate(startOfDay);
    final endTimestamp = Timestamp.fromDate(endOfDay);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: AppColor.primary),
        ),
        titleSpacing: 0,
        title: Text(
          'Orders',
          style: TextStyle(
            color: AppColor.primary,
            fontFamily: 'verdana',
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final picked = await pickDate(context, selectedDate);
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            icon: Icon(Icons.filter_alt, color: AppColor.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusSection(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: collectionOrder
                  .where(
                    'status',
                    isEqualTo: statusOrderToString(selectedStatus),
                  )
                  .where(
                    'dateSendOrder',
                    isGreaterThanOrEqualTo: startTimestamp,
                  )
                  .where('dateSendOrder', isLessThan: endTimestamp)
                  .orderBy('dateSendOrder', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No orders found',
                      style: AppTextStyle.normalText,
                    ),
                  );
                }

                final orders = snapshot.data!.docs.map((doc) {
                  return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final orderDate = order.dateSendOrder ?? DateTime.now();

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.orderDetailScreenAd,
                          arguments: order.id,
                        ),
                        child: OrderCard(
                          orderId: '${order.numberOrder}',
                          userName: order.name,
                          date:
                              '${orderDate.day}-${orderDate.month}-${orderDate.year}',
                          status:
                              statusOrderToString(order.status) ?? 'unknown',
                          flex: flex,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 35,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: StatusOrder.values.map((status) {
            final isSelected = selectedStatus == status;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedStatus = status;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primary
                        // ignore: deprecated_member_use
                        : AppColor.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.name,
                    style: AppTextStyle.normalText.copyWith(
                      color: isSelected ? Colors.black : AppColor.primary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

Future<DateTime?> pickDate(BuildContext context, DateTime initialDate) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.amber,
            onPrimary: Colors.black,
            surface: Colors.grey,
            onSurface: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.amber),
          ),
        ),
        child: child!,
      );
    },
  );

  return picked;
}
