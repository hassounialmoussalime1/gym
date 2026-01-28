import 'package:flutter/material.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/data/services/product_service.dart';

class ProductController extends ChangeNotifier {
  List<ProudctModel> productByCategorie = [];
  List<ProudctModel> bigSalesProduct = [];
  List<ProudctModel> arrivalsProudcts = [];
  List<ProudctModel> featuredProducts = [];
  List<ProudctModel> discountProducts = [];
  final _productService = ProductService();
  bool isLoad = false;
  List<ProudctModel> get filteredProducts {
    if (searchQuery.isEmpty) {
      return productByCategorie;
    } else {
      return productByCategorie.where((product) {
        return product.title.toLowerCase().contains(searchQuery);
      }).toList();
    }
  }

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

  Future<void> getFutureProducts() async {
    isLoad = true;
    featuredProducts = await _productService.getFuturedProduct();
    isLoad = false;
    notifyListeners();
  }

  Future<void> getArrivales() async {
    isLoad = true;
    arrivalsProudcts = await _productService.getProductsNewArrivales();
    isLoad = false;
    notifyListeners();
  }

  Future<void> getDiscountProducts() async {
    isLoad = true;
    discountProducts = await _productService.getDiscountProduct();
    isLoad = false;
    notifyListeners();
  }

  String searchQuery = '';

  void setSearchQuery(String value) {
    searchQuery = value.toLowerCase();
    notifyListeners();
  }
}
