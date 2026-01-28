import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/data/models/cart_item.dart';
import 'package:gym/data/models/order_model.dart';

class OrderService {
  //add order
  Future<void> addOrder(OrderModel newOrder) async {
  try {
    final List<CartItem> copiedProducts = newOrder.products
        .map((p) => CartItem.fromMap(p.toMap()))
        .toList();

    final ref = collectionOrder.doc();

    final countSnapshot = await collectionOrder.count().get();
    final nbOfLastOrder = (countSnapshot.count ?? 0) + 1;

    final orderToSave = OrderModel(
      id: ref.id,
      products: copiedProducts,
      totalePrice: newOrder.totalePrice,
      status: newOrder.status,
      name: newOrder.name,
      phone: newOrder.phone,
      deliveryFee: newOrder.deliveryFee,
      dateSendOrder: newOrder.dateSendOrder,
      dateUpdate: newOrder.dateUpdate,
      adress: newOrder.adress,
      numberOrder: nbOfLastOrder,
    );

    await ref.set(orderToSave.toMap());

    for (CartItem item in copiedProducts) {
      final productRef = collectionProducts.doc(item.productId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snap = await transaction.get(productRef);

        if (!snap.exists) return;

        final data = snap.data() as Map<String, dynamic>;
        final int oldSales = data['sels'] ?? 0;
        final int oldQuantity = data['quantiti'] ?? 0;
        final int orderedQty = item.qty;

        transaction.update(productRef, {
          'sels': oldSales + orderedQty,
          'quantiti': oldQuantity - orderedQty,
        });
      });
    }

    print("Order added and products updated successfully!");

  } catch (e) {
    if (kDebugMode) {
      print("Error addOrder: $e");
    }
  }
}


  Future<OrderModel?> fetchOrderById(String orderId) async {
    final doc = await collectionOrder.doc(orderId).get();
    if (!doc.exists) return null;

    return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    await collectionOrder.doc(orderId).update(data);
  }
}
