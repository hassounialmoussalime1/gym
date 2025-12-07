import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference collectionProducts = _firestore.collection(
  'products',
);
final CollectionReference collectionCategories = _firestore.collection(
  'categories',
);
final CollectionReference collectionOrder = _firestore.collection('orders');
