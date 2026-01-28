import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/data/models/category_model.dart';

class CategoriesService {
  Future<List<CategoryModel>> getCategorys() async {
    try {
      final data = await collectionCategories.get();
      return data.docs
          .map(
            (doc) => CategoryModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('error get categorie: $e');
      return [];
    }
  }

  Future<void> addCategorie(CategoryModel newCategorie) async {
    try {
      final docRef = collectionCategories.doc();
      final Map<String, dynamic> data = newCategorie.toMap();
      data['id'] = docRef.id;
      await docRef.set(data);
    } catch (e) {
      print('eroore add new categorie: $e');
    }
  }

  Future<void> updateCategorie(CategoryModel newcat) async {
    try {
      await collectionCategories.doc(newcat.id).set(newcat.toMap());
    } catch (e) {
      print('errore update dat $e');
    }
  }
}
