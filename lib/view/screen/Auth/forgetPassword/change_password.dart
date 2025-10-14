import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/forget_password_controller.dart';
import 'package:nas/controller/login_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/primary_button.dart';
import 'package:nas/view/widget/text_form_filed_widget.dart';

class ChangeToNewPassword extends StatelessWidget {
  const ChangeToNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordController controller =
        Get.find<ForgetPasswordController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),  
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33.0),
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.1),
        
                Image.asset(
                  AppUrl.logo,
                  height: Get.height * 0.1, // 10% من ارتفاع الشاشة
                  width: Get.width * 0.2,
                ),
                SizedBox(height: 10),
                CustomTitle(title: "تغيير كلمة المرور"),
                SizedBox(height: 14),
        
                Text(
                  "استخدم كلمة مرور قوية ويمكنك تذكرها",
                  style: AppTheme.textTheme14,
                ),
        
                SizedBox(height: Get.height * 0.08),
        
                Form(
                  child: Column(
                    children: [
                      GetBuilder<LoginController>(
                        builder:
                            (_) => TextFormFiledWidget(
                              text: "كلمة المرور",
                              isPassword: true,
                              onEditingComplete:
                                  () => controller.passwordFocusNode.unfocus(),
                              focusNode: controller.passwordFocusNode,
                              textEditingController:
                                  controller.passwordController,
                            ),
                      ),
        
                      SizedBox(height: Get.height * 0.06),
        
                      GetBuilder<LoginController>(
                        builder:
                            (_) => TextFormFiledWidget(
                              text: "تأكيد كلمة المرور",
                              isPassword: true,
                              onEditingComplete:
                                  () =>
                                      controller.confirmPasswordFocusNode
                                          .unfocus(),
                              focusNode: controller.confirmPasswordFocusNode,
                              textEditingController:
                                  controller.confirmPasswordController,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.1),
        
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onTap: () {
                          controller.updatePassword();
                        },
                        text: "تاكيد",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
