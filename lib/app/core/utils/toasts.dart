import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Toasts {
  static void showSuccess(String message, {String? title}) {
    _show(message, Colors.green, Icons.check_circle, title: title ?? 'Success');
  }

  static void showError(String message, {String? title}) {
    _show(message, Colors.red, Icons.error, title: title ?? 'Error');
  }

  static void showInfo(String message, {String? title}) {
    _show(message, Colors.blue, Icons.info, title: title ?? 'Info');
  }

  static void _show(
    String message,
    Color color,
    IconData icon, {
    required String title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = Get.context!;

    // Hide any existing snackbars before showing a new one
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(icon,
                  color: Colors.white, size: 28, key: ValueKey(icon)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title.isNotEmpty)
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  Text(
                    message,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: color.withOpacity(0.95),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)), // Rounded corners
        margin: EdgeInsets.all(16), // Adds shadow effect
      ),
    );
  }
}
