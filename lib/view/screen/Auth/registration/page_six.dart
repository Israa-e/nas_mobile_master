import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_six_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/screen/main/location.dart';
import 'package:nas/view/widget/build_text_field.dart';
import 'package:nas/view/widget/custom_dropdown.dart';
import 'package:nas/view/widget/custom_title.dart';

class PageSix extends StatelessWidget {
  final PageSixController controller;
  const PageSix({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTitle(title: "مكان السكن ؟"),
              SizedBox(height: 10),

              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    BuildTextField(
                      text: "المحافظة",
                      fontSize: 18,
                      focusNode: controller.governorateFocusNode,
                      controller: controller.governorateController,
                      onEditingComplete:
                          () => controller.handleFocusTransition(
                            controller.governorateFocusNode,
                            controller.districtFocusNode,
                          ),
                    ),
                    SizedBox(height: 20),

                    BuildTextField(
                      text: "المنطقة/الحي",
                      fontSize: 18,

                      focusNode: controller.districtFocusNode,
                      controller: controller.districtController,
                      onEditingComplete:
                          () => controller.handleFocusTransition(
                            controller.districtFocusNode,
                            controller.locationFocusNode,
                          ),
                    ),
                    SizedBox(height: 20),

                    BuildTextField(
                      text: "الموقع",
                      fontSize: 18,

                      focusNode: controller.locationFocusNode,
                      controller: controller.locationController,
                      onEditingComplete:
                          () => controller.handleFocusTransition(
                            controller.locationFocusNode,
                            controller.nationalIdFocusNode,
                          ),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Location()),
                          );
                          if (result != null) {
                            controller.locationController.text =
                                result["address"]; // Set the address
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppTheme.white,
                          ),
                          child: SvgPicture.asset(
                            "${AppUrl.rootIcons}/location.svg",
                            color: AppTheme.primaryColor,
                            height: 22, // تحديد الارتفاع داخل `SvgPicture`
                            width: 22, // تحديد العرض داخل `SvgPicture`
                            fit: BoxFit.scaleDown, // يمنع التمدد خارج الحدود
                          ),
                        ),
                      ),
                      // isTapped: controller.locationSelected.value,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 1, color: AppTheme.transparent),
              ),
              SizedBox(height: 24),

              CustomTitle(title: "الجنسية ؟"),
              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          shape: BoxShape.circle,
                        ),
                        margin: EdgeInsets.only(
                          right: 8,
                          left: 2,
                        ), // Responsive margin
                      ),
                      Text(
                        "الجنسية",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Obx(
                    () => CustomDropdown(
                      width: 135,
                      items: controller.genderOptions,
                      hint: 'الجنسية',
                      value: controller.selectedGender.value,

                      onChanged: (value) {
                        print(value);
                        controller.selectedGender.value = value!;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),

              BuildTextField(
                width: 135, // Set a fixed width for all text fields
                text: "الرقم الوطني/الإقامة",
                fontSize: 20,

                focusNode: controller.nationalIdFocusNode,
                controller: controller.nationalIdController,
                onEditingComplete:
                    () => controller.nationalIdFocusNode.unfocus(),

                // isTapped: controller.nationalIdSelected.value,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
