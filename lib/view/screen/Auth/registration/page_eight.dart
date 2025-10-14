import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nas/controller/registration/page_eight_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_title.dart';

import '../../../widget/build_text_field.dart';

class PageEight extends StatelessWidget {
  final PageEightController controller;
  const PageEight({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTitle(title: "الوثائق"),
          SizedBox(height: 10),
          _buildDocumentUploadButton(
            title: 'صورة شخصية',
            supTitle: "يفضل انت تكون الخلفية بيضاء ",

            onPressed: controller.selectPersonalImage,
          ),
          _buildDocumentUploadButton(
            title: 'صورة الهوية من الامام',
            supTitle: "(للجوازات: الصفحة التي تحتوي على الصورة الشخصية)",
            onPressed: controller.selectFrontIDImage,
          ),
          _buildDocumentUploadButton(
            title: 'صورة الهوية من الخلف',
            supTitle: "(للجوازات: الصفحة التي تحتوي على لاصق بـ 10 ارقام)",
            onPressed: controller.selectBackIDImage,
          ),

          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(color: AppTheme.transparent),
          ),
          CustomTitle(
            title: "إنشاء كلمة مرور",
            supText: true,
            supTitle: "(6 خانات على الأقل)",
          ),
          SizedBox(height: 8),
          BuildTextField(
            focusNode: controller.newPasswordFocusNode,
            controller: controller.newPasswordController,
            text: "كلمة المرور الجديدة",
            onEditingComplete: () {
              controller.newPasswordFocusNode.unfocus();
              FocusScope.of(
                context,
              ).requestFocus(controller.confirmPasswordFocusNode);
            },
          ),
          SizedBox(height: 10),

          BuildTextField(
            focusNode: controller.confirmPasswordFocusNode,
            controller: controller.confirmPasswordController,
            text: "اعادة كلمة المرور",
            onEditingComplete: () {
              controller.confirmPasswordFocusNode.unfocus();
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildDocumentUploadButton({
  required String title,
  required String supTitle,

  required VoidCallback onPressed,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 13.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      shape: BoxShape.circle,
                    ),
                    margin: EdgeInsets.only(
                      right: 8,
                      left: 2,
                    ), // Responsive margin
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: AutoSizeText(
                  supTitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.white,
                  ),
                  minFontSize:
                      6, // You can adjust this value to prevent the text from getting too small
                  maxLines: 2, // Limit the number of lines
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 23,
          child: MaterialButton(
            onPressed: onPressed,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppTheme.white, width: 2),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.add, color: AppTheme.white, size: 10),
                SizedBox(width: 5),
                Text(
                  "إرفاق",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
