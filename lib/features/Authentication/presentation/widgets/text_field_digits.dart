import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationCustomTextFieldDigits extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final VoidCallback? onSuffixIconTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AuthenticationCustomTextFieldDigits({
    super.key,
    this.obscureText = false,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onSuffixIconTap,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
    this.validator,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.blue,
          onChanged: onChanged,
            keyboardType: keyboardType ?? TextInputType.number,
            inputFormatters: inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],


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
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
