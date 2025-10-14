import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_eight_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/build_password_field.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/primary_button.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final PageEightController controller = Get.find<PageEightController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
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
                    title: "إنشاء كلمة مرور",
                    supText: true,
                    supTitle: "(6 خانات على الأقل)",
                  ),
                  SizedBox(height: 14),

                  buildPasswordField(
                    focusNode: controller.oldPasswordFocusNode,
                    textController: controller.oldPasswordController,
                    text: "كلمة المرور القديمة",
                    onEditingComplete:
                        () => controller.handleFocusTransition(
                          controller.oldPasswordFocusNode,
                          controller.newPasswordFocusNode,
                        ),
                  ),
                  SizedBox(height: 10.h),
                  buildPasswordField(
                    focusNode: controller.newPasswordFocusNode,
                    textController: controller.newPasswordController,
                    text: "كلمة المرور الجديدة",
                    onEditingComplete:
                        () => controller.handleFocusTransition(
                          controller.newPasswordFocusNode,
                          controller.confirmPasswordFocusNode,
                        ),
                  ),
                  SizedBox(height: 10.h),

                  buildPasswordField(
                    focusNode: controller.confirmPasswordFocusNode,
                    textController: controller.confirmPasswordController,
                    text: "اعادة كلمة المرور",
                    onEditingComplete:
                        () => controller.confirmPasswordFocusNode.unfocus(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: Get.height / 10,
          left: 50.w,
          right: 50.w,
        ),
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
