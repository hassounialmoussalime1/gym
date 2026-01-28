import 'package:flutter/material.dart';
import 'package:gym/data/models/category_model.dart';
import 'package:gym/data/services/categories_service.dart';

class CategorieController extends ChangeNotifier {
  final _categoriService = CategoriesService();

  List<CategoryModel> categories = [];

  void getCategorie() async {
    categories = await _categoriService.getCategorys();
    notifyListeners();
  }

  void addCategorie(CategoryModel newcatg) {
    _categoriService.addCategorie(newcatg);
  }
}
