import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/core/theme/app_theme.dart';
import 'package:gym/firebase_options.dart';
import 'package:gym/view/futures/homeScreen/home_screen.dart';
import 'package:gym/viewmodel/cart_controller.dart';
import 'package:gym/viewmodel/categorie_controller.dart';
import 'package:gym/viewmodel/order_controller.dart';
import 'package:gym/viewmodel/product_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final cartController = CartController();
  await cartController.loadCartFromLocal();

  runApp(
    MultiProvider(
      providers: [
        /// قسم الكاتيجوري
        ChangeNotifierProvider(create: (_) => CategorieController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,

          /// Routes
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: child,
        );
      },

      /// الصفحة الأساسية
      child: const HomeScreen(),
    );
  }
}
