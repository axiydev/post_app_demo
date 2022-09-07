import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscureText;
  final String? placeholder;
  final TextInputAction textInputAction;
  const CustomTextfield(
      {Key? key,
      required this.controller,
      required this.placeholder,
      this.textInputAction = TextInputAction.next,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      textInputAction: textInputAction,
      placeholder: placeholder,
      obscureText: obscureText!,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue),
      placeholderStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.blue.withOpacity(0.5)),
      decoration: BoxDecoration(
          color: Colors.grey[300]!, borderRadius: BorderRadius.circular(8)),
    );
  }
}
