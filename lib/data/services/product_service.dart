import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/data/models/proudct_model.dart';

class ProductService {
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
      print('eror get data by categorie to this id $categorieId beacuse $e');
      return [];
    }
  }

  //get product from db
  Future<List<ProudctModel>> getProductbigSels() async {
    try {
      final data = await collectionProducts
          .orderBy('sels', descending: true)
          .limit(3)
          .get();
      final docs = data.docs;
      print('done');
      return docs
          .map(
            (doc) => ProudctModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('eror get data big sels to this id  beacuse $e');
      return [];
    }
  }
}
