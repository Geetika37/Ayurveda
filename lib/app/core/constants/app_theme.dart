import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData theme = _buildTheme();

  static ThemeData _buildTheme() {
    // Use a base theme for reference.
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.scafflodBackgroundColor,
      primaryColor: AppColors.primaryColor,
      appBarTheme: AppBarTheme(backgroundColor: AppColors.white),
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // backgroundColor: AppColors.brownColor,
          foregroundColor: AppColors.white,
          textStyle: base.textTheme.labelMedium!.copyWith(
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.black,
      ),
      // Text Theme
      textTheme: base.textTheme.copyWith(
        /// H3 bold
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),

        /// H6 sb subheading
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),

        /// H4 medium
        headlineSmall: GoogleFonts.montserrat(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),

        // H5 m
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),

        /// paragrah 1 r
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),

        // paragraph 2 r
        bodySmall: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),

        /// for selected bottom navigation bar item
        displaySmall: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),

        /// H7sb
        labelLarge: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),

        /// H2 b
        displayLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),

        /// 24 600
        titleLarge: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),

        /// 16 400
        titleMedium: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),

        /// 14 400
        titleSmall: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        // 16 600
        labelMedium: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),

        /// 10 w300
        labelSmall: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),

        displayMedium: GoogleFonts.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),

      /// Dropdown Menu Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          alignLabelWithHint: true,
          labelStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.greyColor,
          ),
          filled: true,
          fillColor: AppColors.textfieldfillColor,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      /// Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: base.textTheme.bodyLarge!.copyWith(
          color: AppColors.primaryColor,
        ),
        filled: true,
        fillColor: AppColors.textfieldfillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.redColor),
        ),
        hintStyle: base.textTheme.displayMedium,
        errorStyle: base.textTheme.displaySmall!.copyWith(
          color: AppColors.redColor,
        ),
        labelStyle: base.textTheme.displayMedium!.copyWith(
          color: AppColors.greyColor,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
      ),
    );
  }
}
