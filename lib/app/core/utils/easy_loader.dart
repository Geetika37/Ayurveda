import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingUtil {
  static void showLoading([String? message]) {
    EasyLoading.show(
      status: message ?? 'Loading...',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }

  static void showError(String message) {
    EasyLoading.showError(message);
  }
}
