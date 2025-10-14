import 'package:flutter/material.dart';
import 'package:nas/view/widget/custom_dropdown.dart';
import 'package:nas/view/widget/custom_text_form_field.dart';

Row phoneTextFiled({
  focusNode,
  textController,
  final VoidCallback? onEditingComplete,

  isTapped,
  item,
  value,
  onChanged,
}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(
        flex: 3,
        child: CustomTextField(
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          keyboardType: TextInputType.phone,
          textEditingController: textController,
          height: 32,
        ),
      ),
      SizedBox(width: 5),

      CustomDropdown(
        items: item,
        value: value,
        hint: 'اليوم',
        width: 60,
        onChanged: onChanged,
      ),
    ],
  );
}
