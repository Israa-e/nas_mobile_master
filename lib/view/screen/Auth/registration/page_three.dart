import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_three_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_checkbox.dart';
import 'package:nas/view/widget/custom_title.dart';

class PageThree extends StatelessWidget {
  final PageThreeController controller;

  const PageThree({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTitle(
              title: "شو أيامك المفضلة ؟",
              supText: true,
              supTitle: "بتقدر تختار اكتر من شي...",
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
    );
  }
}
