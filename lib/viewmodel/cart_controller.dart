import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/data/models/cart_item.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  List<CartItem> cartItems = [];

  /// إضافة منتج للكارت (يزيد الكمية إذا موجود مسبقاً)
  void addProduct(ProudctModel product) {
    final index = cartItems.indexWhere((item) => item.productId == product.id);
    if (index >= 0) {
      cartItems[index].qty += 1;
    } else {
      cartItems.add(
        CartItem(
          productId: product.id,
          title: product.title,
          image: product.image,
          price: product.price,
        ),
      );
    }
    saveCartLocally();
    notifyListeners();
  }

  void removeProduct(String productId) {
    cartItems.removeWhere((item) => item.productId == productId);
    saveCartLocally();
    notifyListeners();
  }

  void updateQty(String productId, int qty) {
    final index = cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      cartItems[index].qty = qty;
      saveCartLocally();
      notifyListeners();
    }
  }

  void clearCart() {
    cartItems.clear();
    saveCartLocally();
    notifyListeners();
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.qty);

  /// حفظ الكارت محلياً
  Future<void> saveCartLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cartItems.map((e) => e.toMap()).toList());
    await prefs.setString('cart', jsonString);
  }

  /// جلب الكارت من التخزين المحلي عند تشغيل التطبيق
  Future<void> loadCartFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      cartItems = decoded.map((e) => CartItem.fromMap(e)).toList();
      notifyListeners();
    }
  }
}
