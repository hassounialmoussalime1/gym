import 'package:cloud_firestore/cloud_firestore.dart';

class ProudctModel {
  final String id;
  final String title;
  final String descreption;
  final String image;
  final double price;
  final double discount; // 👈 جديد
  final String categorieId;
  final DateTime date;
  final bool isFeatured;
  final int quantiti;
  final int sels;
  final DateTime lastUpdate;

  ProudctModel({
    required this.id,
    required this.title,
    required this.image,
    required this.categorieId,
    required this.price,
    this.discount = 0, // 👈 افتراضي
    required this.sels,
    required this.date,
    required this.lastUpdate,
    required this.isFeatured,
    required this.quantiti,
    required this.descreption,
  });

  factory ProudctModel.fromMap(Map<String, dynamic> data) {
    return ProudctModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      categorieId: data['categorieId'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(), // 👈 مهم
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      sels: data['sels'] ?? 0,
      lastUpdate: data['lastUpdate'] != null
          ? (data['lastUpdate'] as Timestamp).toDate()
          : DateTime.now(),
      isFeatured: data['isFeatured'] ?? false,
      quantiti: data['quantiti'] ?? 0,
      descreption: data['descreption'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'discount': discount, // 👈 جديد
      'date': date,
      'sels': sels,
      'isFeatured': isFeatured,
      'lastUpdate': lastUpdate,
      'categorieId': categorieId,
      'quantiti': quantiti,
      'descreption': descreption,
    };
  }
}
