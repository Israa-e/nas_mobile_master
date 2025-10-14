import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';

Widget buildHeader({image, text}) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: 40),
    padding: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: AppTheme.primaryColor, width: 3),
      boxShadow: [
        BoxShadow(
          color: Color(0x3F000000),
          blurRadius: 4,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color(0x3F000000),
          blurRadius: 4,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          "${AppUrl.rootIcons}/$image.svg",
          color: AppTheme.primaryColor,
          height: 22, // تحديد الارتفاع داخل `SvgPicture`
          width: 22, // تحديد العرض داخل `SvgPicture`
        ),
        SizedBox(width: 10),
        Text(
          text ?? "طلبات جديدة",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
