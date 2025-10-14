import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nas/controller/registration/page_four_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/build_text_field.dart';
import 'package:nas/view/widget/custom_checkbox.dart';
import 'package:nas/view/widget/custom_title.dart';

class PageFour extends StatelessWidget {
  final PageFourController controller;

  const PageFour({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTitle(
              title: "ساعات العمل ؟",
              supText: true,
              supTitle: "بتقدر تختار اكتر من شي...",
            ),

            // Subtitle
            SizedBox(height: 10),

            Obx(
              () =>
                  controller.workHourOptions.isEmpty
                      ? Center(
                        child: Text(
                          "لا توجد خيارات متاحة حاليًا",
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 16, // Responsive font size
                          ),
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          controller.workHourOptions.length,
                          (index) => CustomCheckbox(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            richText: RichText(
                              textDirection:
                                  TextDirection.rtl, // For Arabic text
                              text: TextSpan(
                                children: controller.getUnderlinedTextSpans(
                                  controller.workHourOptions[index],
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                            widget: RichText(
                              textDirection:
                                  TextDirection.rtl, // For Arabic text
                              text: TextSpan(
                                children: controller.getUnderlinedPriceSpans(
                                  controller.workHourPrices[index],
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                            isSelected: controller.selectedWorkHours.contains(
                              controller.workHourOptions[index],
                            ),
                            onChanged:
                                () => controller.toggleWorkHour(
                                  controller.workHourOptions[index],
                                ),
                            title: '',
                          ),
                        ),
                      ),
            ),
            SizedBox(height: 16), // Responsive spacing

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
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'CLIQ',
                      style: TextStyle(
                        color: AppTheme.white,
                        decorationColor: AppTheme.white,
                        fontSize: 22,
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
                SizedBox(height: 10),
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
                SizedBox(height: 10),

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
    );
  }
}
