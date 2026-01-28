import 'package:flutter/material.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/tools/storage_Service.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/data/services/product_service.dart';
import 'package:image_picker/image_picker.dart';

class AdminProductController extends ChangeNotifier {
  int productNb = 0;
  List<ProudctModel> allProducts = [];
  List<ProudctModel> products = [];
  bool isLoading = false;
  final storage = FirebaseStorageService();
  final _productService = ProductService();

  Future<void> getProductCount() async {
    final snapshot = await collectionProducts.get();
    productNb = snapshot.size;
    notifyListeners();
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required int qty,
    required String categorieId,
    required bool isFeature,
    required double discount,
    XFile? imageFile,
  }) async {
    if (name.isEmpty) {
      throw Exception("Please fill all fields");
    }

    isLoading = true;
    notifyListeners();

    String imageUrl = '';
    if (imageFile != null) {
      final uploadedUrl = await storage.uploadImage(imageFile, 'products');
      if (uploadedUrl == null) {
        isLoading = false;
        notifyListeners();
        throw Exception("Image upload failed");
      }
      imageUrl = uploadedUrl;
    }

    final newProduct = ProudctModel(
      id: '',
      title: name,
      image: imageUrl,
      categorieId: categorieId,
      price: price,
      sels: 0,
      date: DateTime.now(),
      lastUpdate: DateTime.now(),
      isFeatured: isFeature,
      descreption: description,
      discount: discount,
      quantiti: qty,
    );

    await _productService.addProduct(newProduct);

    isLoading = false;
    getProductCount();
    notifyListeners();
  }

  Future<void> getProducts() async {
    isLoading = true;
    allProducts = await _productService.getProduct();
    products = allProducts;
    isLoading = false;
    notifyListeners();
  }

  //update categorie
  Future<void> updateProduct(
    String idDoc,
    String name,
    String descreption,
    double price,
    int qty,
    bool isFeatured,
    ProudctModel pr,
    double discount,
    XFile? imageFile,
  ) async {
    isLoading = true;
    String imageUrl = '';
    if (imageFile != null) {
      final uploadedUrl = await storage.uploadImage(imageFile, 'products');
      if (uploadedUrl == null) {
        isLoading = false;
        notifyListeners();
        throw Exception("Image upload failed");
      }
      imageUrl = uploadedUrl;
    }

    final product = ProudctModel(
      id: idDoc,
      title: name,
      image: imageFile != null ? imageUrl : pr.image,
      categorieId: pr.categorieId,
      price: price,
      sels: pr.sels,
      date: pr.date,
      discount: discount,
      lastUpdate: DateTime.now(),
      isFeatured: isFeatured,
      quantiti: qty,
      descreption: descreption,
    );
    await _productService.updateProduct(product);
    isLoading = false;
    notifyListeners();
  }

  //delet product
  Future<void> deleteProduct(String id) async {
    await _productService.deleteProduct(id);
    notifyListeners();
  }
  //search

  void searchProducts(String query) {
    if (query.isEmpty) {
      products = allProducts;
    } else {
      products = allProducts.where((p) {
        return p.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
