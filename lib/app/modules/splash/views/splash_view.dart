import 'package:ayurvedaapp/app/core/constants/app_images.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        Appimages.splashImage,
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
