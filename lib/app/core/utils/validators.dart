class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? bloodGroupValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Blood group is required';
    }
    final validBloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    if (!validBloodGroups.contains(value.toUpperCase())) {
      return 'Please enter a valid blood group (e.g., A+, B-, AB+, O-)';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  static String? requiredValidator(String? value, String? message) {
    if (value == null || value.isEmpty) {
      return message ?? 'This Field is required';
    }
    return null;
  }

  static String? passwordChecker(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

 




}
