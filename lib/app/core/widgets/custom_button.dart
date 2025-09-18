import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color buttoncolor;
  final Color textcolor;
  final double width;
  final double height;
  final double radius;
  final double space;
  final TextStyle? textStyle;
  final String? logo;
  final Icon? icon;

  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.buttoncolor,
    required this.textcolor,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 10,
    this.space = 8,
    this.textStyle,
    this.logo,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == double.infinity ? null : width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: buttoncolor,
          minimumSize: Size(double.infinity, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child:
            isLoading
                ? SpinKitThreeBounce(color: AppColors.primaryColor, size: 30)
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (logo != null) ...[
                      SvgPicture.asset(
                        logo!,
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                      ),
                      Gap(space),
                    ],
                    Text(
                      text,
                      style:
                          textStyle ??
                          Get.textTheme.headlineSmall!.copyWith(
                            color: textcolor,
                          ),
                    ),
                    if (icon != null) ...[Gap(space), icon!],
                  ],
                ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color buttoncolor;
  final Color backgroundcolor;
  final Color textcolor;
  final double width;
  final double height;
  final double radius;
  final double space;
  final TextStyle? textStyle;
  final String? logo;

  const CustomOutlineButton({
    required this.text,
    required this.onPressed,
    required this.buttoncolor,
    this.backgroundcolor = Colors.transparent,
    required this.textcolor,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 10,
    this.space = 8,
    this.textStyle,
    this.logo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == double.infinity ? null : width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: backgroundcolor,
          minimumSize: Size(double.infinity, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          side: BorderSide(color: buttoncolor, width: 2),
        ),
        child:
            isLoading
                ? SpinKitThreeBounce(color: AppColors.primaryColor)
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (logo != null) ...[
                      SvgPicture.asset(
                        logo!,
                        height: 24.37,
                        width: 24.37,
                        fit: BoxFit.contain,
                      ),
                      Gap(space),
                    ],
                    Text(
                      text,
                      style:
                          textStyle ??
                          Get.textTheme.headlineSmall!.copyWith(
                            color: textcolor,
                          ),
                    ),
                  ],
                ),
      ),
    );
  }
}
