import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffix,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines,
    this.label,
  }) : super(key: key);

  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        errorText: errorText,
        label: label,
        labelStyle: const TextStyle(
          color: kColorPrimaryDark,
          fontSize: 20,
        ),
        hintStyle: const TextStyle(
          color: kColorGrey,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kColorGrey,
            width: 0.5,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kColorPrimary,
            width: 1,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kColorRed,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 25,
          minHeight: 25,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  prefixIcon,
                  color: kColorGrey,
                  size: 16,
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 25,
          minHeight: 25,
        ),
        suffixIcon: suffix,
      ),
      cursorColor: kColorPrimary,
      cursorWidth: 1,
    );
  }
}
