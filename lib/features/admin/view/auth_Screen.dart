// ignore: deprecated_member_use
// ignore_for_file: use_build_context_synchronously

import 'dart:html' as html; 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/firebase_constatnt.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gym/l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initFirebase();
    _checkAdminToken();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: kIsWeb
          ? DefaultFirebaseOptions.web
          : DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _checkAdminToken() {
    if (kIsWeb) {
      final token = html.window.localStorage['adminToken'];
      if (token != null && token == 'ADMIN_TOKEN_2025') {
        Future.microtask(() {
          Navigator.pushReplacementNamed(context, AppRoutes.homeScreenAd);
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final localise = AppLocalizations.of(context)!;
    final isMobile = flex.deviceType == DeviceType.mobile;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: flex.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: flex.screenWidth,
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon:
                          const Icon(Icons.arrow_back, color: AppColor.primary),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isMobile ? flex.width(0.4) : flex.width(0.2),
                height: isMobile ? flex.width(0.3) : flex.width(0.1),
                child: Image.asset(
                  'assets/images/mainimage.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: isMobile ? flex.height(0.03) : 70),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 200),
                child: TextField(
                  controller: emailController,
                  style: AppTextStyle.normalText,
                  decoration: InputDecoration(
                    label: Text(
                      localise.email,
                      style: AppTextStyle.normalText.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: flex.height(0.03)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 200),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: AppTextStyle.normalText,
                  decoration: InputDecoration(
                    label: Text(
                      localise.password,
                      style: AppTextStyle.normalText.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? flex.height(0.06) : 70),
              GestureDetector(
                onTap: isLoading ? null : () => login(context),
                child: Container(
                  height: 50,
                  width: flex.width(isMobile ? 0.9 : 0.4),
                  decoration: BoxDecoration(
                    color: isLoading ? Colors.grey : AppColor.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Login', style: AppTextStyle.normalTextBold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final doc = await collectionAdmin
          .doc('info')
          .get();

      if (!doc.exists) {
        _showMessage(context, 'بيانات الادمن غير موجودة');
        return;
      }

      final storedEmail = doc['email'];
      final storedPassword = doc['password'];

      if (email == storedEmail && password == storedPassword) {
        if (kIsWeb) {
          html.window.localStorage['adminToken'] = 'ADMIN_TOKEN_2025';
        }

        String? fcmToken;

        try {
          fcmToken = await FirebaseMessaging.instance.getToken(
            vapidKey: kIsWeb
                ? 'BPcwNL9AOmbuMLGirOJL9cqAPJzbey8_rY_c7ZZbY9praH_Rvbmp_FU-bcaODafkQkU72ELrGoK5yRpPFXsTM4g'
                : null,
          );
          if (kDebugMode) {
            print('FCM Token: $fcmToken');
          }
        } catch (e) {
          if (kDebugMode) {
            print('FCM token error: $e');
          }
        }

        if (fcmToken != null) {
          await collectionAdminTokens
              .doc('main_admin')
              .set({
            'token': fcmToken,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          if (kDebugMode) {
            print('FCM Token saved: $fcmToken');
          }
        }

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreenAd,
          (_) => false,
        );
      } else {
        _showMessage(context, 'البريد أو كلمة السر خاطئة');
      }
    } catch (e) {
      _showMessage(context, 'حدث خطأ: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
