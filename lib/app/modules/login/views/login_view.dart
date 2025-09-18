import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:ayurvedaapp/app/core/constants/app_images.dart';
import 'package:ayurvedaapp/app/core/utils/validators.dart';
import 'package:ayurvedaapp/app/core/widgets/custom_button.dart';
import 'package:ayurvedaapp/app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Top Image
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/loginpage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      Appimages.splashlogo,
                      height: 80,
                      width: 80,
                    ),
                  ),
                ],
              ),

              // Login Card
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(30),

                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login Or Register To Book\nYour Appointments',
                        style: Get.textTheme.headlineMedium!,
                      ),

                      const SizedBox(height: 30),

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
    );
  }
}
