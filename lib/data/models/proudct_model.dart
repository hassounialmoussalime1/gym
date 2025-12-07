import 'package:cloud_firestore/cloud_firestore.dart';

class ProudctModel {
  final String id;
  final String title;
  final String image;
  final double price;
  final String categorieId;
  final DateTime date;
  final int sels;
  final DateTime lastUpdate;

  ProudctModel({
    required this.id,
    required this.title,
    required this.image,
    required this.categorieId,
    required this.price,
    required this.sels,
    required this.date,
    required this.lastUpdate,
  });

  factory ProudctModel.fromMap(Map<String, dynamic> data) {
    return ProudctModel(
      id: data['id'],
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      categorieId: data['categorieId'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      sels: data['sels'] ?? 0,
      lastUpdate: data['lastUpdate'] != null
          ? (data['lastUpdate'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'date': date,
      'sels': sels,
      'lastUpdate': lastUpdate,
      'categorieId': categorieId,
    };
  }
}
