import 'package:flutter/material.dart';
import 'package:gym/data/models/category_model.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/features/admin/view/categortie_feature/add_Categorie_Screen.dart';
import 'package:gym/features/admin/view/auth_Screen.dart';
import 'package:gym/features/admin/view/categortie_feature/categorie_Screen_admin.dart';
import 'package:gym/features/admin/view/categortie_feature/categorie_detail.dart';
import 'package:gym/features/admin/view/categortie_feature/update_categorie_screen.dart';
import 'package:gym/features/admin/view/home_screen_admin.dart';
import 'package:gym/features/admin/view/order_detail_screen_admn.dart';
import 'package:gym/features/admin/view/order_screen_ad.dart';
import 'package:gym/features/admin/view/product_feature/admin_Add_product.dart';
import 'package:gym/features/admin/view/product_feature/admin_product_screen.dart';
import 'package:gym/features/admin/view/product_feature/admin_update_product.dart';
import 'package:gym/features/admin/view/profile_info_Screen.dart';
import 'package:gym/features/custommer/view/aboutScreen/about_screen.dart';
import 'package:gym/features/custommer/view/cart_Screen/cart_Screen.dart';
import 'package:gym/features/custommer/view/category/categorie_detail_screen.dart';
import 'package:gym/features/custommer/view/check_out/check_out_screen.dart';
import 'package:gym/features/custommer/view/contactScreen/contact_Screen.dart';
import 'package:gym/features/custommer/view/futuredscreenproduct/futured_screen_product.dart';
import 'package:gym/features/custommer/view/homeScreen/home_screen.dart';
import 'package:gym/features/custommer/view/product_screen/product_detail_Screen.dart';
import 'package:gym/features/custommer/view/product_screen/product_screen.dart';

class AppRoutes {
  static String home = 'homescreen';
  static String productScreen = 'productScreen';
  static String aboutScreen = 'aboutScreen';
  static String contactsceen = 'contactsceen';
  static String cartScreen = 'cartScreen';
  static String checkOutScreen = 'checkoutScreen';
  static const String categorieDetaiScreen = '/categorieDetaiScreen';
  static const String futuredProductScreen = '/futuredProductScreen';
  //admin
  static const String authScreenAd = '/authScreenAd';
  static const String homeScreenAd = '/homeScreenAd';
  static const String orderScreenAd = '/orderScreenAd';
  static const String orderDetailScreenAd = '/orderDetailScreenAd';
  static const String categorieScreenAd = '/categorieScreenAd';
  static const String addCategorieScreen = "/addCategorieScreen";
  static const String updateCAtegorieScreen = '/updateCAtegorieScreen';
  static const String categorieDetailScreenAd = '/categorieDetailScreenAd';
  static const String addProductScreeenAd = '/addProductScreeenAd';
  static const String updateProductScreeenAd = '/updateProductScreeenAd';
  static const String adminProductScreen = '/adminProductScreen';
  static const String profileInfoScreen = '/profileInfoScreen';
  static const String productDetail = '/productDetail';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    productScreen: (context) => ProductScreen(),
    aboutScreen: (context) => AboutScreen(),
    contactsceen: (context) => ContactScreen(),
    cartScreen: (context) => CartScreen(),
    checkOutScreen: (context) => CashOutPage(),
    //admin screens
    authScreenAd: (context) => AuthScreen(),
    homeScreenAd: (context) => HomeScreenAdmin(),
    orderScreenAd: (context) => OrderScreenAd(),
    categorieScreenAd: (context) => CategorieScreenAdmin(),
    addCategorieScreen: (context) => AddCategorieScreen(),
    adminProductScreen: (context) => AdminProductScreen(),
    profileInfoScreen: (context) => ProfileInfoScreen()
  };
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case categorieDetaiScreen:
        final categorie = settings.arguments as CategoryModel;
        return MaterialPageRoute(
          builder: (_) => CategoryDetailPage(category: categorie),
        );
      case futuredProductScreen:
        final map = settings.arguments as Map<String, dynamic>;
        bool isarrivals = map['isarrivals'];
        bool isTopSeler = map['isTopSeler'];
        bool isFeatured = map['isFeatured'];
        return MaterialPageRoute(
          builder: (_) => FuturedScreenProduct(
            isTopSeler: isTopSeler,
            isarrivals: isarrivals,
            isFeatured: isFeatured,
          ),
        );
      //admin
      case orderDetailScreenAd:
        final orderId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreenAdmn(idOrder: orderId),
        );
      case updateCAtegorieScreen:
        final categorie = settings.arguments as CategoryModel;
        return MaterialPageRoute(
          builder: (_) => updateCategorieScreen(categorie: categorie),
        );
      case categorieDetailScreenAd:
        final categorie = settings.arguments as CategoryModel;
        return MaterialPageRoute(
          builder: (_) => CategorieDetailAdmin(category: categorie),
        );
      case addProductScreeenAd:
        final categorieId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => adminAddProductScreen(categorieId: categorieId),
        );
      case updateProductScreeenAd:
        final product = settings.arguments as ProudctModel;
        return MaterialPageRoute(
          builder: (_) => adminUpdateProductScreen(product: product),
        );
      case productDetail:
        final product = settings.arguments as ProudctModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );
    }
    return null;
  }
}
