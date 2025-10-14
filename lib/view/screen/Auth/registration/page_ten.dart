import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_ten_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_checkbox.dart';
import 'package:nas/view/widget/custom_title.dart';

class PageTen extends StatelessWidget {
  final PageTenController controller;
  const PageTen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(title: "الشروط والأحكام ", isIcon: false),

              SizedBox(height: 20),
              // Tasks List
              Obx(
                () =>
                    controller.terms.isEmpty
                        ? Text(
                          "لا توجد مهام متاحة حاليًا",
                          style: TextStyle(color: AppTheme.white, fontSize: 16),
                        )
                        : Column(
                          children: List.generate(
                            controller.terms.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                top:
                                    index == controller.terms.length - 1
                                        ? 10
                                        : 0,
                              ),
                              child: CustomCheckbox(
                                crossAxisAlignment:
                                    index == controller.terms.length - 1
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    index == controller.terms.length - 1
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.white,
                                ),
                                richText: Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.white,
                                      ),
                                      children: controller
                                          .getUnderlinedTextSpans(
                                            controller.terms[index],
                                            index,
                                          ),
                                    ),
                                    textDirection:
                                        TextDirection
                                            .rtl, // Important for Arabic text
                                  ),
                                ),
                                onChanged: () {
                                  controller.toggleSelection(
                                    index,
                                  ); // This function returns void, so no need to use the result.
                                },
                                isSelected: controller.selectedTerms[index],
                                title: '',
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
