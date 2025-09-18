import 'package:ayurvedaapp/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.labelText,
    this.readOnly = false,
    this.prefix,
    this.validator,
    this.suffix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? labelText;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      readOnly: readOnly,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

class CustomTextfieldPreference extends StatelessWidget {
  const CustomTextfieldPreference({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        // style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.greyColor.withOpacity(0.7),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.redColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.redColor, width: 2),
          ),
        ),
      ),
    );
  }
}
