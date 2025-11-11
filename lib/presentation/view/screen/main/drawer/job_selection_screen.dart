import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_two_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/presentation/view/widget/button_border.dart';
import 'package:nas/presentation/view/widget/custom_checkbox.dart';
import 'package:nas/presentation/view/widget/custom_radio_button.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';
import 'package:nas/presentation/view/widget/custom_title.dart';
import 'package:nas/presentation/view/widget/primary_button.dart';

class JobSelectionScreen extends StatefulWidget {
  const JobSelectionScreen({super.key});

  @override
  State<JobSelectionScreen> createState() => _JobSelectionScreenState();
}

class _JobSelectionScreenState extends State<JobSelectionScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Load user data from database
  Future<void> loadUserData() async {
    try {
      int? userId = await SharedPrefsHelper.getUserId();
      if (userId == null) {
        setState(() => isLoading = false);
        return;
      }

      DatabaseHelper dbHelper = DatabaseHelper.instance;
      List<Map<String, dynamic>> userDetails = await dbHelper.getAllUsersById(
        userId,
      );

      if (userDetails.isNotEmpty) {
        userData = userDetails[0];
        print("user data: $userData");

        // Load selected tasks into controller
        final PageTwoController controller = Get.find<PageTwoController>();
        await controller.loadUserSelectedTasks(userData!);
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('Error getting user data: $e');
      setState(() => isLoading = false);
    }
  }

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
                onTap: () async {
                  if (!controller.validate()) return;

                  // Save to database
                  if (userData != null) {
                    await saveUserTasks(userData!['id']);
                  }
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

  Future<void> saveUserTasks(int userId) async {
    try {
      final PageTwoController controller = Get.find<PageTwoController>();
      DatabaseHelper dbHelper = DatabaseHelper.instance;

      // Get selected tasks as JSON string
      Map<String, dynamic> formData = controller.getFormData();
      String selectedTasksJson = jsonEncode(formData['selectedTasks']);

      // Update database
      await dbHelper.updateUser(userId, {
        'selectedTasks': selectedTasksJson,
        'acceptAlcohol': formData['acceptAlcohol'] == true ? 1 : 0,
      });
      showSuccessSnackbar(message: 'تم حفظ اختياراتك بنجاح');
      Future.delayed(const Duration(milliseconds: 500), () {
        print('🔍 About to navigate back');
        print('🔍 Can pop: ${Navigator.of(context).canPop()}');
        print('🔍 Get route name: ${Get.currentRoute}');

        // Try multiple methods to ensure navigation
        Get.closeAllSnackbars(); // Close snackbar
        Navigator.of(context, rootNavigator: true).pop(); // Use root navigator

        print('🔍 After pop - route: ${Get.currentRoute}');
      });
    } catch (e) {
      print('Error saving tasks: $e');

      showErrorSnackbar(message: 'فشل حفظ الاختيارات');
    }
  }
}
