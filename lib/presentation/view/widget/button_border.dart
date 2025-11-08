import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';

class ButtonBorder extends StatelessWidget {
  final Function() onTap;
  final String? text;
  final Widget? widget;
  final double? height;
  final double? borderRadius;

  final Color? color;
  final TextStyle? textStyle;
  const ButtonBorder({
    super.key,
    this.widget,
    this.textStyle,
    required this.onTap,
    this.color,
    this.text,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Get.height * 0.05, // تقريبًا 50px
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? AppTheme.white,
          side: BorderSide(color: color ?? AppTheme.white, width: 2),

          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.005, // تقريبًا 4px
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? Get.width * 0.015, // تقريبًا 5px
            ),
          ),
        ),
        child:
            widget ??
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
              child: Text(
                "$text",
                style:
                    textStyle ??
                    AppTheme.textTheme16.copyWith(
                      color: color ?? AppTheme.white,
                    ),
              ),
            ),
      ),
    );
  }
}
