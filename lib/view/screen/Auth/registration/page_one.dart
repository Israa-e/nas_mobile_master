import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_one_controller.dart';
import 'package:nas/view/widget/custom_radio_button.dart';
import 'package:nas/view/widget/custom_text_form_field.dart';
import 'package:nas/view/widget/custom_title.dart';

class PageOne extends StatelessWidget {
  final PageOneController controller;
  const PageOne({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent layout errors

          children: [
            CustomTitle(title: "من وين سمعت عنا ؟"),

            SizedBox(height: 20),
            Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min, // هذا يمنع حدوث الأخطاء

                children: [
                  ...controller.sources
                      .map(
                        (source) => CustomRadioButton(
                          title: source,
                          isSelected: controller.selectedSource.value == source,
                          onTap: () => controller.selectSource(source, context),
                        ),
                      )
                      // ignore: unnecessary_to_list_in_spreads
                      .toList(),
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomRadioButton(
                          title: 'أخرى',
                          isSelected: controller.isOtherSelected.value,
                          onTap: () => controller.selectOther(),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          focusNode: controller.otherFocusNode,
                          textEditingController:
                              controller.otherSourceController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
