import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool? isPassword;
  final double? height;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  final TextInputType? keyboardType;
  final VoidCallback? onEditingComplete;

  final Widget? suffixIcon;
  final FocusNode? focusNode; // Add FocusNode here
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.textEditingController,
    this.isPassword,
    this.validator,
    this.onChange,
    this.keyboardType,
    this.suffixIcon,
    this.focusNode,
    this.height,
    this.maxLines,
    this.onEditingComplete,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 32,
      child: Focus(
        onFocusChange: (focus) {
          setState(() {
            isFocused = focus;
          });
        },
        child: TextFormField(
          focusNode: widget.focusNode, // Use the FocusNode
          controller: widget.textEditingController,
          onChanged: widget.onChange,
          onEditingComplete: widget.onEditingComplete,
          obscureText: widget.isPassword ?? false,
          keyboardType: widget.keyboardType,
          validator: widget.validator ?? _defaultValidator,
          maxLines: widget.maxLines ?? 1,
          textAlignVertical: TextAlignVertical.center,
          cursorHeight: Get.height * 0.025, // Adjust this value as needed
          cursorWidth: Get.width * 0.004,
          decoration: InputDecoration(
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 5, // No vertical padding
              horizontal: 10,
            ),
            fillColor: isFocused ? AppTheme.white : Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.white, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.white, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.red, width: 2),
            ),
            suffixIcon: widget.suffixIcon,
          ),

          style: TextStyle(
            color: isFocused ? AppTheme.primaryColor : AppTheme.white,
            fontSize: 14, // Responsive font size
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

String? _defaultValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  return null;
}
