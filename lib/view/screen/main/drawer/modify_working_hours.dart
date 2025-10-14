import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_four_controller.dart';
import 'package:nas/controller/registration/page_three_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_checkbox.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/primary_button.dart';

class ModifyWorkingHours extends StatelessWidget {
  const ModifyWorkingHours({super.key});

  @override
  Widget build(BuildContext context) {
    final PageFourController controller2 = Get.find<PageFourController>();
    final PageThreeController controller = Get.find<PageThreeController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTitle(
                    title: "ساعات العمل ؟",
                    supText: true,
                    supTitle:
                        "تعديل ساعات العمل"
                        "بتقدر تختار اكتر من شي...",
                  ),

                  SizedBox(height: 20.h),

                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: List.generate(
                        controller2.workHourOptions.length,
                        (index) => CustomCheckbox(
                          richText: RichText(
                            textDirection: TextDirection.rtl, // For Arabic text
                            text: TextSpan(
                              children: controller2.getUnderlinedTextSpans(
                                controller2.workHourOptions[index],
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                          widget: RichText(
                            textDirection: TextDirection.rtl, // For Arabic text
                            text: TextSpan(
                              children: controller2.getUnderlinedPriceSpans(
                                controller2.workHourPrices[index],
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                          isSelected: controller2.selectedWorkHours.contains(
                            controller2.workHourOptions[index],
                          ),
                          onChanged:
                              () => controller2.toggleWorkHour(
                                controller2.workHourOptions[index],
                              ),
                          title: '',
                        ),
                      ),
                    ),
                  ),

                  CustomTitle(
                    title: "شو أيامك المفضلة ؟",
                    supText: true,
                    supTitle: 'يمكنك اختيار اكثر من شي',
                  ),

                  // Days List
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 20, // Horizontal space between items
                    runSpacing: 10, // Vertical space between rows
                    children: List.generate(controller.days.length, (index) {
                      final day = controller.days[index];
                      return Obx(
                        () => CustomCheckbox(
                          title: "",
                          richText: Text(
                            day,
                            softWrap:
                                true, // Allow text to wrap when it exceeds width
                            overflow:
                                TextOverflow
                                    .ellipsis, // Truncate the text if it's too long
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.white,
                            ),
                          ),
                          isSelected: controller.selectedDays.contains(day),
                          onChanged: () => controller.toggleDay(day),
                        ),
                      );
                    }),
                  ),

                  CustomTitle(title: "شو أوقاتك المفضلة؟"),
                  SizedBox(height: 10.h),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: controller.times.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final time = controller.times[index];
                      // Wrap only the checkbox with Obx for efficient rebuilds
                      return Obx(
                        () => CustomCheckbox(
                          title: time,
                          textStyle: AppTheme.textTheme20,
                          isSelected: controller.selectedTimes.contains(time),
                          onChanged: () => controller.toggleTime(time),
                        ),
                      );
                    },
                  ),
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
