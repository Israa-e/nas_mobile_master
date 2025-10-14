import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final double? height;
  final double? borderRadius;

  final Color? color;
  final Color? textColor;
  const PrimaryButton({
    super.key,
    required this.onTap,
    this.color,
    this.textColor,
    required this.text,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Get.height * 0.05, // تقريبًا 50px
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppTheme.white,
          foregroundColor: AppTheme.primaryColor,
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.005, // تقريبا 4px
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? Get.width * 0.015, // تقريبا 5px
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
          child: Text(
            text,
            style:
            //  TextStyle(
            //   fontSize: 16,
            //   color: textColor ?? AppTheme.primaryColor,
            // ),
            AppTheme.textTheme16.copyWith(
              color: textColor ?? AppTheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
