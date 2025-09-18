import 'package:ayurvedaapp/app/core/utils/storageutil.dart';
import 'package:ayurvedaapp/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    navigateToOnboard();
  }

  Future<void> navigateToOnboard() async {
    final isUserLoggedIn = await StorageUtil.isUserLoggedIn();
    await Future.delayed(Duration(seconds: 3), () {
      if (isUserLoggedIn) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }
}
