import 'package:flutter/material.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/data/services/product_service.dart';

class ProductController extends ChangeNotifier {
  List<ProudctModel> productByCategorie = [];
  List<ProudctModel> bigSalesProduct = [];
  final _productService = ProductService();
  bool isLoad = false;

  //get productYcategorie
  Future<void> getProductByCategorie(String idCategorie) async {
    isLoad = true;
    productByCategorie = await _productService.getProductByCategorie(
      idCategorie,
    );

    isLoad = false;
    notifyListeners();
  }

  Future<void> getbigSalesProduct() async {
    isLoad = true;
    bigSalesProduct = await _productService.getProductbigSels();
    isLoad = false;
    notifyListeners();
  }
}
