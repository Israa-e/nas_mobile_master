import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/forget_password_controller.dart';
import 'package:nas/controller/login_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/primary_button.dart';
import 'package:nas/view/widget/text_form_filed_widget.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

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
                  width: Get.width * 0.3,
                  height: Get.width * 0.3,
                ),
                SizedBox(height: 10),
                CustomTitle(title: "هل نسيت كلمة المرور؟"),
                SizedBox(height: 13),

                Text(
                  "أدخل رقمك هاتفك لنرسل لك كود التحقق",
                  style: AppTheme.textTheme14.copyWith(),
                ),

                SizedBox(height: Get.height * 0.1),

                Form(
                  key: controller.phoneFormKey,
                  child: GetBuilder<LoginController>(
                    builder:
                        (_) => TextFormFiledWidget(
                          text: 'رقم الهاتف',
                          keyboardType: TextInputType.phone,
                          onEditingComplete:
                              () => controller.handleFocusTransition(
                                controller.phoneFocusNode,
                                controller.passwordFocusNode,
                              ),
                          focusNode: controller.phoneFocusNode,
                          textEditingController: controller.phoneController,
                        ),
                  ),
                ),
                SizedBox(height: Get.height * 0.1),

                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        height: 36,
                        onTap: () {
                          controller.sendCode();
                        },
                        text: "إرسال",
                      ),
                    ),

                    SizedBox(width: Get.width * 0.08),

                    Expanded(
                      child: ButtonBorder(
                        height: 36,

                        onTap: () {
                          Get.back();
                        },
                        text: "عودة",
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
