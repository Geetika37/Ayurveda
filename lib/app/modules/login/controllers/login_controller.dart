import 'dart:developer';
import 'package:ayurvedaapp/app/core/constants/app_urls.dart';
import 'package:ayurvedaapp/app/core/utils/storageutil.dart';
import 'package:ayurvedaapp/app/core/utils/toasts.dart';
import 'package:ayurvedaapp/app/data/services/api_service.dart';
import 'package:ayurvedaapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final ApiService apiService = ApiService();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        final response = await apiService.postRequest(
          url: AppUrls.login,
          data: {
            'username': emailController.text,
            'password': passwordController.text,
          },
        );
        log('Login Response: $response');
        if (response != null && response['status'] == true) {
          if (response['token'] != null) {
            await StorageUtil.saveBearerToken(response['token']);
            Get.toNamed(Routes.HOME);
            Toasts.showSuccess('Login successful!');
          }
        } else {
          Toasts.showError('Login failed. Please check your credentials.');
        }
      } catch (e) {
        log('Login Error: $e');
        Toasts.showError('Login failed. Please try again.$e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
