import 'package:flutter/material.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';

class CustomTitle extends StatelessWidget {
  final String? title;
  final String? supTitle;
  final Widget? widget;
  final bool? isIcon;
  final bool? supText;
  final Color? color;

  const CustomTitle({
    super.key,
    required this.title,
    this.isIcon = true,
    this.widget,
    this.supText,
    this.color,
    this.supTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        isIcon == true
            ? Container(
              margin: EdgeInsets.only(left: 20),
              child: Image.asset("${AppUrl.rootImages}/icon1.png"),
            )
            : SizedBox.shrink(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          decoration: BoxDecoration(
            color: color != null ? AppTheme.white : AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color ?? AppTheme.white, width: 2),
          ),
          child: Center(
            child:
                widget ??
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color ?? AppTheme.white,
                  ),
                ),
          ),
        ),
        supText == true ? SizedBox(height: 8) : SizedBox.shrink(),
        supText == true
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(right: 8, left: 2),
                ),
                Text(
                  "بإمكانك تغيير الخيارات لاحقاً",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
