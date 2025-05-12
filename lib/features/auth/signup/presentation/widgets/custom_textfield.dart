import 'package:convo/core/utils/values_manager.dart';
import 'package:flutter/material.dart';

class buildTextField extends StatelessWidget {
  buildTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.validationType,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String validationType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPading.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: AppSize.s18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSize.s8),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: (value) => choseType(validationType, value),
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff6D6A6A)),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? choseType(String type, String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  switch (type) {
    case 'email':
      if (!value.isValidEmail(value)) {
        return 'Please enter a valid email';
      }
      break;
    case 'password':
      if (!value.isValidPassword(value)) {
        return 'Password must be 8+ chars with uppercase, lowercase, number and special char';
      }
      break;
    case 'name':
      if (!value.isValidName(value)) {
        return 'Please enter a valid name';
      }
      break;
    case 'phone':
      if (!value.isValidPhone(value)) {
        return 'Please enter a valid phone number';
      }
      break;
    case 'confirmPassword':
      if (!value.isPasswordMatch(value, value)) {
        return 'Passwords do not match';
      }
      break;
  }
  return null; 
}
