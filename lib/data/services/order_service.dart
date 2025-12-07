import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/data/models/order_model.dart';

class OrderService {
  //add order
  Future<void> addOrder(OrderModel newOrder) async {
    try {
      await collectionOrder.add(newOrder.toMap());
    } catch (e) {}
  }
}
