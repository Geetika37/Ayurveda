import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:ayurvedaapp/app/core/utils/validators.dart';
import 'package:ayurvedaapp/app/core/widgets/custom_button.dart';
import 'package:ayurvedaapp/app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/loginpage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.spa, color: Colors.white, size: 40),
                  ),

                  const SizedBox(height: 40),

                  // Login Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            'Login Or Register To Book\nYour Appointments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),

                          // Email Field
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextfield(
                            controller: controller.emailController,
                            validator: Validators.nameValidator,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter email',
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextfield(
                            controller: controller.passwordController,
                            validator: Validators.passwordValidator,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter Password',
                          ),

                          const SizedBox(height: 30),

                          // Login Button
                          Obx(
                            () => CustomButton(
                              isLoading: controller.isLoading.value,
                              text: 'Login',
                              onPressed: () {
                                controller.login();
                              },
                              buttoncolor: AppColors.primaryColor,
                              textcolor: AppColors.white,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Terms and Privacy Policy
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                                children: const [
                                  TextSpan(
                                    text:
                                        'By creating or logging into an account you are agreeing\nwith our ',
                                  ),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
