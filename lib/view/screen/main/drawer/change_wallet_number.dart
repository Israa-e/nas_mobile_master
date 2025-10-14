import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_four_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/build_text_field.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_title.dart';

import '../../../widget/primary_button.dart';

class ChangeWalletNumber extends StatelessWidget {
  const ChangeWalletNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final PageFourController controller = Get.find<PageFourController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              children: [
                SizedBox(height: Get.height * 0.05), // 5% من ارتفاع الشاشة
        
                Image.asset(
                  AppUrl.logo,
                  height: Get.height * 0.1, // 10% من ارتفاع الشاشة
                  width: Get.width * 0.3,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(height: Get.height / 8),
        
                CustomTitle(
                  title: "قبض المستحقات؟ CLIQ",
                  supText: true,
                  supTitle: "بإمكانك تغيير الخيارات لاحقاً",
        
                  widget: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'قبض المستحقات؟ ',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'CLIQ',
                          style: TextStyle(
                            color: AppTheme.white,
                            decorationColor: AppTheme.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
        
                  children: [
                    BuildTextField(
                      text: "اسم صاحب الحساب",
                      controller: controller.accountNameController,
                      focusNode: controller.accountNameFocusNode,
                      onEditingComplete: () {
                        controller.accountNameFocusNode.unfocus();
                        FocusScope.of(
                          context,
                        ).requestFocus(controller.departmentNameFocusNode);
                      },
                    ),
                    SizedBox(height: 16.h),
                    BuildTextField(
                      text: "اسم الجهة",
                      controller: controller.departmentNameController,
                      focusNode: controller.departmentNameFocusNode,
                      onEditingComplete: () {
                        controller.departmentNameFocusNode.unfocus();
                        FocusScope.of(
                          context,
                        ).requestFocus(controller.accountNumberFocusNode);
                      },
                    ),
                    SizedBox(height: 16.h),
        
                    BuildTextField(
                      text: "رقم المحفظة",
                      controller: controller.accountNumberController,
                      focusNode: controller.accountNumberFocusNode,
                      onEditingComplete: () {
                        controller.accountNumberFocusNode.unfocus();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: Get.height / 10, left: 50, right: 50),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onTap: () {
                  Get.back();
                },
                text: "حفظ",
              ),
            ),

            SizedBox(width: 40.w),

            Expanded(
              child: ButtonBorder(
                onTap: () {
                  Get.back();
                },
                text: "عودة",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
