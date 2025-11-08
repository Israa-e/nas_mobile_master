import 'package:flutter/material.dart';
import 'package:nas/core/constant/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final bool isTapped;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final double height;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    this.isTapped = false,
    this.height = 60,
    this.controller,
    this.suffixIcon,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isTapped ? AppTheme.white : AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isTapped ? AppTheme.primaryColor : AppTheme.white,
            width: 2,
          ),
          boxShadow:
              isTapped
                  ? [
                    BoxShadow(
                      color: Color(0x3F000000),

                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
        ),
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,

          onChanged: onChanged,

          textAlignVertical:
              TextAlignVertical.center, // يضمن محاذاة النص مع المؤشر
          cursorHeight:
              height / 2.6, // Reduce height (default is usually the font size)
          cursorWidth: 1.5,
          style: TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: suffixIcon ?? SizedBox.shrink(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: height / 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
