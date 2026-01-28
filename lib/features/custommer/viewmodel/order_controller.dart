import 'package:flutter/material.dart';
import 'package:gym/core/tools/enums.dart';
import 'package:gym/data/models/cart_item.dart';
import 'package:gym/data/models/order_model.dart';
import 'package:gym/data/services/order_service.dart';

class OrderController extends ChangeNotifier {
  final _orderService = OrderService();
  bool loadOrder = false;
  //add order
  Future<void> addOrder(
    double totalePrice,
    String name,
    String phone,
    String adress,
    final List<CartItem> products,
  ) async {
    loadOrder = true;
    notifyListeners();

    OrderModel newOrder = OrderModel(
      id: '',
      dateSendOrder: DateTime.now(),
      totalePrice: totalePrice,
      status: StatusOrder.newOrder,
      name: name,
      phone: phone,
      products: products,
      deliveryFee: 2,
      numberOrder: 1,
      dateUpdate: '',
      adress: adress,
    );

    await _orderService.addOrder(newOrder);

    loadOrder = false;
    notifyListeners();
  }
}
