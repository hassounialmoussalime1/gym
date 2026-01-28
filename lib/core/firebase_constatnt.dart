import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final String mainDevId = 'Q3PbdYK34tjqK9QnKl7P';
final String mainProdId = '8thlRBeWdHLA2RN9mPyN';

final String mainDev = "mainDev";
final String mainProd = "mainProd";

final DocumentReference collectionMainDev = _firestore
    .collection(kDebugMode ? mainDev : mainProd)
    .doc(kDebugMode ? mainDevId : mainProdId);

final CollectionReference collectionProducts = collectionMainDev .collection(
  'products',
);
final CollectionReference collectionCategories = collectionMainDev.collection(
  'categories',
);
final CollectionReference collectionOrder = collectionMainDev.collection('orders');
final CollectionReference collectionAdmin = collectionMainDev.collection('admin');
final CollectionReference collectionAdminTokens = collectionMainDev.collection('adminTokens');