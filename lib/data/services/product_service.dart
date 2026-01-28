import 'package:flutter/foundation.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/data/models/proudct_model.dart';

class ProductService {
  Future<List<ProudctModel>> getProduct() async {
    try {
      final data = await collectionProducts.get();
      final docs = data.docs;
      return docs
          .map(
            (doc) => ProudctModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('eror get data beacuse $e');
      }
      return [];
    }
  }

  //get product from db
  Future<List<ProudctModel>> getProductByCategorie(String categorieId) async {
    try {
      final data = await collectionProducts
          .where('categorieId', isEqualTo: categorieId)
          .get();
      final docs = data.docs;
      return docs
          .map(
            (doc) => ProudctModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('eror get data by categorie to this id $categorieId beacuse $e');
      }
      return [];
    }
  }

  //get product from db
  Future<List<ProudctModel>> getProductbigSels() async {
    try {
      final data = await collectionProducts
          .orderBy('sels', descending: true)
          .limit(10)
          .get();
      final docs = data.docs;
      if (kDebugMode) {
        print('done');
      }
      return docs
          .map(
            (doc) => ProudctModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('eror get data big sels to this id  beacuse $e');
      }
      return [];
    }
  }

  //get product from db
  Future<List<ProudctModel>> getProductsNewArrivales() async {
    try {
      final data = await collectionProducts
          .orderBy('date', descending: true)
          .limit(4)
          .get();
      final docs = data.docs;
      if (kDebugMode) {
        print('done');
      }
      return docs
          .map(
            (doc) => ProudctModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('eror get data big sels to this id  beacuse $e');
      }
      return [];
    }
  }

  Future<List<ProudctModel>> getFuturedProduct() async {
    try {
      final data =
          await collectionProducts.where('isFeatured', isEqualTo: true).get();
      final docs = data.docs;
      return docs
          .map((e) => ProudctModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('error get futured data beacuse $e');
      }
      return [];
    }
  }

  //add product
  Future<void> addProduct(ProudctModel newProduct) async {
    try {
      final docRef = collectionProducts.doc();
      final Map<String, dynamic> data = newProduct.toMap();
      data['id'] = docRef.id;
      await docRef.set(data);
    } catch (E) {
      if (kDebugMode) {
        print('errore add product $E');
      }
    }
  }
  //update categorie

  Future<void> updateProduct(ProudctModel newpr) async {
    try {
      await collectionProducts.doc(newpr.id).set(newpr.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('errore update dat $e');
      }
    }
  }
  //update categorie

  Future<void> deleteProduct(String idDoc) async {
    try {
      await collectionProducts.doc(idDoc).delete();
    } catch (e) {
      if (kDebugMode) {
        print('errore delete data $e');
      }
    }
  }

  Future<List<ProudctModel>> getDiscountProduct() async {
    try {
      final query =
          await collectionProducts.where('discount', isGreaterThan: 0).get();
      final docs = query.docs;
      return docs
          .map(
              (doc) => ProudctModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('errore get discounts data : $e');
      }
      return [];
    }
  }
}
