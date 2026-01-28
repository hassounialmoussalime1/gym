import 'dart:html' as html;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/core/theme/app_theme.dart';
import 'package:gym/features/admin/viewModel/admin_categorie_Controler.dart';
import 'package:gym/features/admin/viewModel/admin_order_controller.dart';
import 'package:gym/features/admin/viewModel/admin_product_controller.dart';
import 'package:gym/features/custommer/viewmodel/localization_controller.dart';
import 'package:gym/firebase_options.dart';
import 'package:gym/features/custommer/viewmodel/cart_controller.dart';
import 'package:gym/features/custommer/viewmodel/categorie_controller.dart';
import 'package:gym/features/custommer/viewmodel/order_controller.dart';
import 'package:gym/features/custommer/viewmodel/product_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  final cartController = CartController();
  await cartController.loadCartFromLocal();
  setUrlStrategy(PathUrlStrategy());
  runApp(
    MultiProvider(
      providers: [
        /// constumer
        ChangeNotifierProvider(create: (_) => CategorieController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        //admin
        ChangeNotifierProvider(create: (_) => AdminOrderController()),
        ChangeNotifierProvider(create: (_) => AdminProductController()),
        ChangeNotifierProvider(create: (_) => AdminCategorieController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localLang = Provider.of<LocaleProvider>(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,

          locale: localLang.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Power Gear - Top Quality Power Tools Online',

          /// Routes
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: child,
        );
      },

      /// الصفحة الأساسية
      child: const SplashOrLoginScreen(),
    );
  }
}

class SplashOrLoginScreen extends StatelessWidget {
  const SplashOrLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تحقق من وجود Token للـ Admin
    final token = html.window.localStorage['adminToken'];

    Future.microtask(() {
      if (token != null && token == 'ADMIN_TOKEN_2025') {
        // admin موجود، روح مباشرة لصفحة الادمن
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreenAd);
      } else {
        // مستخدم عادي أو غير مسجل → اذهب لصفحة Customer Homepage
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
