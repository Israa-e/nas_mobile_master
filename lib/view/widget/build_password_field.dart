import 'package:flutter/material.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_text_form_field.dart';
import 'package:nas/view/widget/phone_text_filed.dart';

import 'custom_dropdown.dart';

Widget buildPasswordField({
  required String text,
  textController,
  focusNode,
  isPhone = false,
  final VoidCallback? onEditingComplete,

  isOnlyDropDown = false,
  double? width,
  item,
  value,
  onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.white,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 8, left: 2),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      SizedBox(
        width: width ?? 146,
        child:
            isOnlyDropDown
                ? CustomDropdown(
                  items: item,
                  value: value,
                  hint: 'اليوم',
                  onChanged: onChanged,
                )
                : isPhone
                ? phoneTextFiled(
                  textController: textController,
                  onEditingComplete: onEditingComplete,
                  focusNode: focusNode,
                  item: item,
                  value: value,
                  onChanged: onChanged,
                )
                : CustomTextField(
                  focusNode: focusNode,
                  textEditingController: textController,
                  height: 32,
                ),
      ),
    ],
  );
}
