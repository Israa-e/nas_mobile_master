// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';

class CustomCheckbox extends StatelessWidget {
  final String? title;
  final Widget? richText;
  final bool isSelected;
  final bool icon;
  final double? width;
  final VoidCallback onChanged;
  final VoidCallback? onIconTap;
  final isCircle;
  final textStyle;
  final mainAxisAlignment;
  final String? message;
  final crossAxisAlignment;
  final Widget? widget;
  final padding;

  const CustomCheckbox({
    super.key,
    this.title,
    required this.isSelected,
    this.isCircle = false,
    this.widget,
    this.icon = false,
    this.textStyle,
    required this.onChanged,
    this.width,
    this.richText,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.padding,
    this.message,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        color: Colors.transparent, // color added back
        padding: EdgeInsets.symmetric(vertical: 6), // Adjust padding
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            // Checkbox-like indicator
            Container(
              width: 16, // Adjust width for responsive design
              height: 16, // Adjust height for responsive design
              margin: padding ?? EdgeInsets.zero,
              decoration:
                  isCircle
                      ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: isSelected ? Colors.transparent : Colors.white,
                      )
                      : BoxDecoration(
                        color: isSelected ? AppTheme.white : Colors.transparent,
                        border: Border.all(color: AppTheme.white, width: 2),
                        borderRadius: BorderRadius.circular(Get.width * 0.005),
                      ),

              child:
                  isCircle
                      ? isSelected
                          ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          )
                          : null
                      : null,
            ),

            SizedBox(width: 9),

            // Task Text
            richText ?? Text(title!, style: textStyle ?? AppTheme.textTheme16),
            if (widget != null || icon) Spacer(),

            // Custom Widget
            if (widget != null) widget!,
            // Icon
            if (icon)
              GestureDetector(
                onTap: onIconTap,
                child: Image.asset(
                  "${AppUrl.rootImages}/vector1.png",
                  height: 16,
                  width: 16,
                  fit: BoxFit.scaleDown,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
