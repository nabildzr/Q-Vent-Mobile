import 'package:flutter/material.dart';

class AuthenticationCustomTextFieldLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const AuthenticationCustomTextFieldLabel({super.key, required this.text,  this.color});

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyle(color: color ?? Colors.black),));
  }
}
