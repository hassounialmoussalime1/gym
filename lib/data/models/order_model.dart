import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/core/tools/enums.dart';
import 'package:gym/data/models/cart_item.dart';

class OrderModel {
  final String id;
  final List<CartItem> products;
  final DateTime? dateSendOrder;
  final double totalePrice;
  final StatusOrder? status;
  final String name;
  final String phone;
  final double? deliveryFee;
  final int numberOrder;
  final String? dateUpdate;
  final String adress;

  OrderModel({
    required this.id,
    required this.dateSendOrder,
    required this.totalePrice,
    required this.status,
    required this.name,
    required this.phone,
    required this.products,
    required this.deliveryFee,
    required this.numberOrder,
    required this.dateUpdate,
    required this.adress,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'],
      products: (data['products'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromMap(e))
          .toList(),
      dateSendOrder: data['dateSendOrder'] != null
          ? (data['dateSendOrder'] as Timestamp).toDate()
          : null,
      totalePrice: (data['totalePrice'] ?? 0.0).toDouble(),
      name: data['name'] ?? "",
      phone: data['phone'] ?? "",
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      numberOrder: data['numberOrder'] ?? 0,
      dateUpdate: data['dateUpdate'] ?? "",
      status: stringToStatusOrder(data['status']),
      adress: data['adress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': statusOrderToString(status),
      'dateSendOrder': Timestamp.fromDate(dateSendOrder!),
      'products': products.map((e) => e.toMap()).toList(),
      'totalePrice': totalePrice,
      'name': name,
      'phone': phone,
      'deliveryFee': deliveryFee,
      'numberOrder': numberOrder,
      'dateUpdate': dateUpdate,
      'adress': adress,
    };
  }
}
