import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_seven_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/phone_text_filed.dart';
import 'package:nas/view/widget/primary_button.dart';

class EditPhoneNumber extends StatelessWidget {
  const EditPhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final PageSevenController controller = Get.find<PageSevenController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.05), // 5% من ارتفاع الشاشة

                  Image.asset(
                    AppUrl.logo,
                    height: Get.height * 0.1, // 10% من ارتفاع الشاشة
                    width: Get.width * 0.3,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(height: Get.height / 8),

                  Center(
                    child: CustomTitle(
                      title: "رقم الهاتف ؟",
                      supText: true,
                      supTitle: "رقم هاتف يحتوي على واتساب",
                    ),
                  ),
                  SizedBox(height: 14),

                  phoneTextFiled(
                    isTapped: controller.isPhoneSelected.value,
                    textController: controller.phoneController,
                    focusNode: controller.phoneFocusNode,
                    item: controller.countryCodeOptions,
                    value: controller.selectedCountryCode.value,
                    onChanged: controller.setCountryCode,
                    onEditingComplete:
                        () => controller.phoneFocusNode.unfocus(),
                  ),
                  SizedBox(height: Get.height / 9),
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
