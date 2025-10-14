// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_text_form_field.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BuildTextField extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final double? width;
  final VoidCallback? onEditingComplete;

  final Widget? suffixIcon;

  const BuildTextField({
    super.key,
    this.text,
    required this.controller,
    this.focusNode,
    this.suffixIcon,
    this.fontSize,
    this.width,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(
                    right: 8,
                    left: 2,
                  ), // Responsive margin
                ),
                Expanded(
                  child: AutoSizeText(
                    text ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: fontSize ?? 15,
                      fontWeight: FontWeight.w500,
                    ),
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width ?? 144, // Set a fixed width for all text fields
            height: 32, //
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10,
              ), // Rounded corners like in the image
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomTextField(
              focusNode: focusNode,
              onEditingComplete: onEditingComplete,
              textEditingController: controller,
              suffixIcon: suffixIcon,
              onChange: (value) {
                if (controller.text != value) {
                  controller.text = value;
                }
              },
              height: 32,
            ),
          ),
        ],
      ),
    );
  }
}
