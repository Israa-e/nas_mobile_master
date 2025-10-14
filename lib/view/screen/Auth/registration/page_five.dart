import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'package:nas/controller/registration/page_five_controller.dart';
import 'package:nas/view/widget/build_text_field.dart';
import 'package:nas/view/widget/custom_dropdown.dart';
import 'package:nas/view/widget/custom_title.dart';

class PageFive extends StatelessWidget {
  final PageFiveController controller;
  const PageFive({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTitle(
              title: "إسمك رباعي ؟",
              supText: true,
              supTitle: "زي ما هوا بجواز السفر...",
            ),

            SizedBox(height: 20),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  BuildTextField(
                    text: "الاسم الاول",
                    width: 163,
                    fontSize: 18,
                    focusNode: controller.firstNameFocusNode,
                    controller: controller.firstNameController,
                    onEditingComplete: () {
                      controller.familyNameFocusNode.unfocus();
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.fatherNameFocusNode);
                    },
                  ),
                  SizedBox(height: 16),

                  BuildTextField(
                    text: "اسم الاب",
                    fontSize: 18,
                    width: 163,
                    focusNode: controller.fatherNameFocusNode,
                    controller: controller.fatherNameController,
                    onEditingComplete: () {
                      controller.fatherNameFocusNode.unfocus();
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.grandFatherNameFocusNode);
                    },
                  ),
                  SizedBox(height: 16),

                  BuildTextField(
                    text: "اسم الجد",
                    fontSize: 18,
                    width: 163,
                    focusNode: controller.grandFatherNameFocusNode,
                    controller: controller.grandFatherNameController,
                    onEditingComplete: () {
                      controller.grandFatherNameFocusNode.unfocus();
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.familyNameFocusNode);
                    },
                  ),
                  SizedBox(height: 16),

                  BuildTextField(
                    text: "الاسم العائلة",
                    width: 163,
                    fontSize: 18,

                    focusNode: controller.familyNameFocusNode,
                    controller: controller.familyNameController,
                    onEditingComplete: () {
                      controller.familyNameFocusNode.unfocus();
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            CustomTitle(
              title: "تاريخ ميلادك ؟",
              supText: true,
              supTitle: "اليوم/ الشهر / السنة",
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CustomDropdown(
                      items: controller.days,
                      hint: 'اليوم',
                      value: controller.selectedDay.value,

                      onChanged: (value) {
                        controller.selectedDay.value = value!;
                        controller.updateDate();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomDropdown(
                    items: controller.months,
                    hint: 'الشهر',
                    value: controller.selectedMonth.value,
                    onChanged: (value) {
                      controller.selectedMonth.value = value!;
                      controller.updateDate();
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomDropdown(
                    items: controller.years,
                    hint: 'السنة',
                    value: controller.selectedYear.value,

                    onChanged: (value) {
                      controller.selectedYear.value = value!;
                      controller.updateDate();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
