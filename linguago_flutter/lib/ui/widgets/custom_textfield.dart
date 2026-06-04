import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly;
  final int? maxLines;
  final Color? fillColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
    this.fillColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscure,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        validator: widget.validator,
        onChanged: widget.onChanged,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.disableText,
            fontSize: 14,
          ),
          // Langsung pakai widget.prefixIcon tanpa Padding manual
          // prefixIconConstraints memastikan ukuran icon konsisten
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints: widget.prefixIcon != null
              ? const BoxConstraints(minWidth: 44, minHeight: 44)
              : null,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.navInActive,
                      size: 20,
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: widget.isPassword
              ? const BoxConstraints(minWidth: 44, minHeight: 44)
              : null,
          filled: true,
          fillColor: widget.fillColor ??
              (_isFocused
                  ? AppColors.white
                  : const Color(0xFFFAF8FC)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.disableBorder, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primaryPurple, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          errorStyle: const TextStyle(
            fontSize: 12,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}