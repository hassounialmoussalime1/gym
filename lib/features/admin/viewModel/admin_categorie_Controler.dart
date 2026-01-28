// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/tools/storage_Service.dart';
import 'package:gym/data/models/category_model.dart';
import 'package:gym/data/services/categories_service.dart';

class AdminCategorieController extends ChangeNotifier {
  int nbCategorie = 0;
  List<CategoryModel> categories = [];
  bool isLoading = false;
  final _categoriesService = CategoriesService();
  final storage = FirebaseStorageService();
  Future<void> getCategire() async {
    isLoading = true;
    categories = await _categoriesService.getCategorys();
    isLoading = false;
    notifyListeners();
  }

  Future<void> getCategorieNb() async {
    final snapshot = await collectionCategories.get();
    nbCategorie = snapshot.size;
    notifyListeners();
  }

  Future<bool> addCategorie({
    required String name,
    required String description,
    XFile? imageFile,
  }) async {
    if (name.isEmpty) {
      throw Exception("Please fill all fields");
    }
    try {
      isLoading = true;
      notifyListeners();

      String imageUrl = '';
      if (imageFile != null) {
        final uploadedUrl = await storage.uploadImage(imageFile, 'categories');
        if (uploadedUrl == null) {
          isLoading = false;
          notifyListeners();
          throw Exception("Image upload failed");
        }
        imageUrl = uploadedUrl;
      }

      final categorie = CategoryModel(
        id: '',
        categoryName: name,
        imgUrl: imageUrl,
        descreption: description,
        orderCount: 0,
      );

      await _categoriesService.addCategorie(categorie);

      isLoading = false;
      getCategire();
      getCategorieNb();
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('errore');
      }
      return false;
    }
  }

  //update categorie
  void updateCategorie(
    String idDoc,
    String name,
    String descreption,
    XFile? imageFile,
    String? imgUrl,
  ) async {
    isLoading = true;
    String imageUrl = '';
    if (imageFile != null) {
      final uploadedUrl = await storage.uploadImage(imageFile, 'categories');
      if (uploadedUrl == null) {
        isLoading = false;
        notifyListeners();
        throw Exception("Image upload failed");
      }
      imageUrl = uploadedUrl;
    }

    final categorie = CategoryModel(
      id: idDoc,
      categoryName: name,
      imgUrl: imageFile != null ? imageUrl : imgUrl!,
      descreption: descreption,
      orderCount: 0,
    );
    _categoriesService.updateCategorie(categorie);
    await getCategire();
    isLoading = false;
    notifyListeners();
  }
}
