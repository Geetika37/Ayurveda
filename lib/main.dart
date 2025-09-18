import 'package:ayurvedaapp/app/core/constants/app_theme.dart';
import 'package:ayurvedaapp/app/modules/splash/bindings/splash_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ayurveda",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: SplashBinding(),
      theme: AppTheme.theme,
    ),
  );
}
