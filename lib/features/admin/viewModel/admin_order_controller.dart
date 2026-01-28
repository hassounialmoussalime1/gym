import 'package:flutter/material.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/tools/enums.dart';
import 'package:gym/data/models/order_model.dart';
import 'package:gym/data/services/order_service.dart';

class AdminOrderController extends ChangeNotifier {
  int nbOrder = 0;
  final _service = OrderService();
  Future<void> getOrderCount() async {
    final snapshot = await collectionOrder.get();
    nbOrder = snapshot.size;
    notifyListeners();
  }

  bool isLoading = true;
  OrderModel? order;
  String? selectedStatus;


  Future<void> fetchOrder(String orderId) async {
    isLoading = true;
    notifyListeners();

    order = await _service.fetchOrderById(orderId);

    if (order != null) {
      selectedStatus = statusOrderToString(order!.status);
    }

    isLoading = false;
    notifyListeners();
  }


  Future<void> changeStatus(String orderId, String newStatus) async {
    // ignore: unrelated_type_equality_checks
    if (order == null || newStatus == order!.status) return;

    selectedStatus = newStatus;
    notifyListeners();

    await _service.updateOrder(orderId, {'status': newStatus});
  }


  Future<void> changeQty(String orderId, int index, int newQty) async {
    if (order == null) return;

    order!.products[index].qty = newQty;

    double total = 0;
    for (var p in order!.products) {
      total += p.price * p.qty;
    }
    order!.totalePrice = total;

    notifyListeners();

    await _service.updateOrder(orderId, {
      'products': order!.products.map((e) => e.toMap()).toList(),
      'totalePrice': total,
    });
  }
}
