import 'package:flutter/material.dart';
import 'package:gym/core/tools/enums.dart';
import 'package:gym/data/models/order_model.dart';
import 'package:gym/data/services/order_service.dart';
import 'package:gym/viewmodel/cart_controller.dart';

class OrderController extends ChangeNotifier {
  final _orderService = OrderService();
  bool loadOrder = false;
  //add order
  void addOrder(double totalePrice, String name, String phone, String adress) {
    loadOrder = true;
    OrderModel newOrder = OrderModel(
      id: '',
      dateSendOrder: DateTime.now(),
      totalePrice: totalePrice,
      status: StatusOrder.newOrder,
      name: name,
      phone: phone,
      products: CartController().cartItems,
      deliveryFee: 2,
      numberOrder: 1,
      dateUpdate: '',
      adress: adress,
    );
    _orderService.addOrder(newOrder);
    loadOrder = false;
    notifyListeners();
  }
}
