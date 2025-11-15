import 'package:flutter/material.dart';

import 'text_field_label.dart';

class AuthenticationRecoveryPasswordWithLabelValidation
    extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final VoidCallback? onSuffixIconTap;
  final String label;

  const AuthenticationRecoveryPasswordWithLabelValidation({
    super.key,
    this.obscureText = false,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onSuffixIconTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthenticationCustomTextFieldLabel(text: label),
        SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.blue,

          decoration: InputDecoration(
            hintText: hintText,

            prefixIcon: Icon(prefixIcon),
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5F5F5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),

            suffixIcon:
                suffixIcon != null
                    ? (onSuffixIconTap != null
                        ? GestureDetector(
                          onTap: onSuffixIconTap,
                          child: Icon(suffixIcon),
                        )
                        : Icon(suffixIcon))
                    : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        // Align(alignment: Alignment.centerLeft, child: Text("Must be at least 8 character")),
      ],
    );
  }
}
