import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/forget_password_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/custom_otp_field.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/primary_button.dart';

class CodeValidate extends StatelessWidget {
  const CodeValidate({super.key});

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
                CustomTitle(title: "تحقق من الكود"),
                SizedBox(height: 14),
        
                Text(
                  "أدخل كود التحقق حتى تتمكن من إسترجاع الكلمة",
                  style: AppTheme.textTheme14,
                ),
        
                SizedBox(height: Get.height * 0.1),
                Form(
                  child: CustomOtpField(
                    numberOfFields: 4,
                    onSubmit: (String otp) {
                      print("OTP entered: $otp");
                      controller.verifyOtp(otp);
                      // Handle OTP submission
                    },
                  ),
                ),
                SizedBox(height: Get.height * 0.1),
        
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onTap: () {
                          controller.goToChangePassword();
                        },
                        text: "تحقق",
                        height: 36,
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
