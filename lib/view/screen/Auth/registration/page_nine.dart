import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nas/controller/registration/page_nine_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/build_password_field.dart';
import 'package:nas/view/widget/custom_title.dart';

class PageNine extends StatelessWidget {
  final PageNineController controller;
  const PageNine({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTitle(
                title: "القريب الأول ؟",
                supText: true,
                supTitle: "(تستخدم هذه المعلومات بالحالات الطارئة)",
              ),

              SizedBox(height: 12),
              buildPasswordField(
                width: 170,
                onEditingComplete: () {
                  controller.firstNameFocusNode.unfocus();
                  FocusScope.of(
                    context,
                  ).requestFocus(controller.firstPhoneFocusNode);
                },
                focusNode: controller.firstNameFocusNode,
                textController: controller.firstNameController,
                text: "الإسم ثنائي",
              ),
              SizedBox(height: 14),
              Obx(
                () => buildPasswordField(
                  isOnlyDropDown: true,
                  width: 170,

                  text: "صلة القرابة",
                  item: controller.relationTypes,
                  value: controller.firstRelationType.value,
                  onChanged: (value) {
                    controller.firstRelationType.value = value!;
                  },
                ),
              ),
              SizedBox(height: 14),
              buildPasswordField(
                width: 170,

                focusNode: controller.firstPhoneFocusNode,
                textController: controller.firstPhoneController,
                isPhone: true,
                item: controller.countryCodeOptions,
                value: controller.selectedCountryCode.value,
                onChanged: controller.setCountryCode,
                text: "رقم الهاتف",
                onEditingComplete: () {
                  controller.firstPhoneFocusNode.unfocus();
                  FocusScope.of(
                    context,
                  ).requestFocus(controller.secondNameFocusNode);
                },
              ),

              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(color: AppTheme.transparent),
              ),
              CustomTitle(
                title: "القريب الثاني ؟",
                supText: true,
                supTitle: "(تستخدم هذه المعلومات بالحالات الطارئة)",
              ),
              SizedBox(height: 14),
              buildPasswordField(
                width: 170,
                onEditingComplete: () {
                  controller.secondNameFocusNode.unfocus();
                  FocusScope.of(
                    context,
                  ).requestFocus(controller.secondPhoneFocusNode);
                },
                focusNode: controller.secondNameFocusNode,
                textController: controller.secondNameController,
                text: "الإسم ثنائي",
              ),
              SizedBox(height: 14),
              Obx(
                () => buildPasswordField(
                  width: 170,

                  isOnlyDropDown: true,
                  text: "صلة القرابة",
                  item: controller.relationTypes,
                  value: controller.secondRelationType.value,
                  onChanged: (value) {
                    controller.secondRelationType.value = value!;
                  },
                ),
              ),
              SizedBox(height: 14),

              buildPasswordField(
                width: 170,

                focusNode: controller.secondPhoneFocusNode,
                textController: controller.secondPhoneController,
                isPhone: true,
                item: controller.countryCodeOptions,
                value: controller.selectedCountryCode.value,
                onChanged: controller.setCountryCode,
                text: "رقم الهاتف",
                onEditingComplete:
                    () => controller.secondPhoneFocusNode.unfocus(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
