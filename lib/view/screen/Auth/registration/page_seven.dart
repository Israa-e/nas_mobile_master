import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_seven_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_checkbox.dart';

import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/phone_text_filed.dart';

class PageSeven extends StatelessWidget {
  final PageSevenController controller;

  const PageSeven({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTitle(title: "الجنس ؟"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    controller.genderOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String gender = entry.value;

                      return Container(
                        margin: EdgeInsets.only(left: index == 0 ? 50 : 0),
                        child: Obx(
                          () => CustomCheckbox(
                            title: gender,
                            textStyle: AppTheme.textTheme20,

                            isSelected:
                                controller.selectedGender.value == gender,
                            onChanged: () => controller.setGender(gender),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(height: 1, color: AppTheme.transparent),
              ),
              // Subtitle
              SizedBox(height: 12),

              CustomTitle(
                title: "رقم الهاتف ؟",
                supText: true,
                supTitle: "رقم هاتف يحتوي على واتساب",
              ),
              SizedBox(height: 14),

              Obx(
                () => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 33.0),
                  child: phoneTextFiled(
                    onEditingComplete:
                        () => controller.handleFocusTransition(
                          controller.phoneFocusNode,
                          FocusNode(), // Replace with the next focus node if applicable
                        ),
                    isTapped: controller.isPhoneSelected.value,
                    textController: controller.phoneController,
                    focusNode: controller.phoneFocusNode,
                    item: controller.countryCodeOptions,

                    value: controller.selectedCountryCode.value,
                    onChanged: controller.setCountryCode,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(color: AppTheme.transparent, height: 1),
              ),
              SizedBox(height: 17),
              CustomTitle(title: "الحالة الإجتماعية ؟"),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    controller.maritalStatusOptions.asMap().entries.map((
                      entry,
                    ) {
                      int index = entry.key;
                      String status = entry.value;

                      return Container(
                        margin: EdgeInsets.only(
                          left: index == 0 ? 36 : 0,
                        ), // تباعد بين العناصر
                        child: Obx(
                          () => CustomCheckbox(
                            textStyle: AppTheme.textTheme20,
                            title: status,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            isSelected:
                                controller.selectedMaritalStatus.value ==
                                status,
                            onChanged:
                                () => controller.setMaritalStatus(status),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
