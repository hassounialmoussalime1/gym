import 'package:flutter/material.dart';
import 'package:gym/data/models/category_model.dart';
import 'package:gym/view/futures/aboutScreen/about_screen.dart';
import 'package:gym/view/futures/cart_Screen/cart_Screen.dart';
import 'package:gym/view/futures/category/categorie_detail_screen.dart';
import 'package:gym/view/futures/check_out/check_out_screen.dart';
import 'package:gym/view/futures/contactScreen/contact_Screen.dart';
import 'package:gym/view/futures/homeScreen/home_screen.dart';
import 'package:gym/view/futures/product_screen/product_screen.dart';

class AppRoutes {
  static String home = 'homescreen';
  static String productScreen = 'productScreen';
  static String aboutScreen = 'aboutScreen';
  static String contactsceen = 'contactsceen';
  static String cartScreen = 'cartScreen';
  static String checkOutScreen = 'checkoutScreen';
  static const String categorieDetaiScreen = '/categorieDetaiScreen';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    productScreen: (context) => ProductScreen(),
    aboutScreen: (context) => AboutScreen(),
    contactsceen: (context) => ContactScreen(),
    cartScreen: (context) => CartScreen(),
    checkOutScreen: (context) => CashOutPage(),
  };
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case categorieDetaiScreen:
        final categorie = settings.arguments as CategoryModel;
        return MaterialPageRoute(
          builder: (_) => CategoryDetailPage(category: categorie),
        );
    }
    return null;
  }
}
