import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_two_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_checkbox.dart';
import 'package:nas/view/widget/custom_radio_button.dart';
import 'package:nas/view/widget/custom_title.dart';
import 'package:nas/view/widget/primary_button.dart';

class JobSelectionScreen extends StatelessWidget {
  const JobSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageTwoController controller = Get.find<PageTwoController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              SizedBox(height: Get.height / 6),

              CustomTitle(
                title: "شو حابب تشتغل ؟",
                supText: true,
                supTitle: 'يمكنك اختيار اكثر من شي',
              ),

              SizedBox(height: 20.h),
              Obx(
                () =>
                    controller.tasks.isEmpty
                        ? Text(
                          "لا توجد مهام متاحة حاليًا",
                          style: AppTheme.textTheme16,
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            controller.tasks.length,
                            (index) => Container(
                              margin:
                                  controller.selectedWithQuestion.contains(
                                        index,
                                      )
                                      ? EdgeInsets.only(bottom: 19)
                                      : EdgeInsets.zero,
                              padding:
                                  controller.selectedWithQuestion.contains(
                                        index,
                                      )
                                      ? EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 13,
                                      )
                                      : EdgeInsets.symmetric(horizontal: 22),
                              decoration:
                                  controller.selectedWithQuestion.contains(
                                        index,
                                      )
                                      ? BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(25),
                                      )
                                      : BoxDecoration(),
                              child: Column(
                                children: [
                                  CustomCheckbox(
                                    icon: true,
                                    onIconTap:
                                        () =>
                                            controller.showSuccessDialog(index),
                                    title: controller.tasks[index],
                                    textStyle: AppTheme.textTheme20,
                                    isSelected: controller.selectedTasks[index],
                                    onChanged:
                                        () => controller.toggleTask(index),
                                  ),

                                  // Show question if the task is selected
                                  Obx(() {
                                    final isSelected = controller
                                        .selectedWithQuestion
                                        .contains(index);
                                    final question =
                                        controller.taskQuestions[index];
                                    return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 100),
                                      switchInCurve: Curves.easeOutBack,
                                      switchOutCurve: Curves.easeInBack,
                                      transitionBuilder: (
                                        Widget child,
                                        Animation<double> animation,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child:
                                          isSelected
                                              ? Column(
                                                key: ValueKey(
                                                  'question_$index',
                                                ),
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF292929),
                                                          Color(0xFF5D5D5D),
                                                          Color(0xFF292929),
                                                        ],
                                                        begin:
                                                            Alignment
                                                                .centerLeft,
                                                        end:
                                                            Alignment
                                                                .centerRight,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8,
                                                        ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 7,
                                                          height: 7,
                                                          decoration:
                                                              BoxDecoration(
                                                                color:
                                                                    AppTheme
                                                                        .white,
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                          margin:
                                                              EdgeInsets.only(
                                                                right: 8,
                                                                left: 2,
                                                              ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            question,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color:
                                                                  AppTheme
                                                                      .white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            minFontSize: 10,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: CustomRadioButton(
                                                          title: 'نعم',
                                                          size: 15,
                                                          textStyle: AppTheme
                                                              .textTheme14
                                                              .copyWith(
                                                                fontSize: 12,
                                                              ),
                                                          isSelected:
                                                              controller
                                                                  .selectedTasks[index] &&
                                                              controller
                                                                      .taskAnswers[index] ==
                                                                  true,
                                                          onTap:
                                                              () => controller
                                                                  .setTaskAnswer(
                                                                    index,
                                                                    true,
                                                                  ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: CustomRadioButton(
                                                          width: 50,
                                                          title: 'لا',
                                                          size: 15,
                                                          textStyle: AppTheme
                                                              .textTheme14
                                                              .copyWith(
                                                                fontSize: 12,
                                                              ),
                                                          isSelected:
                                                              controller
                                                                  .selectedTasks[index] &&
                                                              controller
                                                                      .taskAnswers[index] ==
                                                                  false,
                                                          onTap:
                                                              () => controller
                                                                  .setTaskAnswer(
                                                                    index,
                                                                    false,
                                                                  ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                              : SizedBox.shrink(),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: Get.height / 10.h,
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
