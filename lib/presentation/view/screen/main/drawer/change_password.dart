import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_eight_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/presentation/view/widget/build_password_field.dart';
import 'package:nas/presentation/view/widget/button_border.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';
import 'package:nas/presentation/view/widget/custom_title.dart';
import 'package:nas/presentation/view/widget/primary_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String password = '';

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      int? userId = await SharedPrefsHelper.getUserId();
      if (userId == null) return null;

      DatabaseHelper dbHelper = DatabaseHelper.instance;
      List<Map<String, dynamic>> userDetails = await dbHelper.getAllUsersById(
        userId,
      );

      if (userDetails.isNotEmpty) {
        password = userDetails[0]['password'];
        print("user password: $password");

        return userDetails[0];
      }

      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  final PageEightController controller = Get.find<PageEightController>();

  @override
  Widget build(BuildContext context) {
    Future<void> saveUserData() async {
      try {
        int? userId = await SharedPrefsHelper.getUserId();
        if (userId == null) return;

        DatabaseHelper dbHelper = DatabaseHelper.instance;

        await dbHelper.updateUser(userId, {
          'password': controller.newPasswordController.text.trim(),
        });

        showSuccessSnackbar(message: 'تم حفظ كلمة المرور بنجاح');
        Future.delayed(const Duration(milliseconds: 500), () {
          print('🔍 About to navigate back');
          print('🔍 Can pop: ${Navigator.of(context).canPop()}');
          print('🔍 Get route name: ${Get.currentRoute}');

          // Try multiple methods to ensure navigation
          Get.closeAllSnackbars(); // Close snackbar
          Navigator.of(
            context,
            rootNavigator: true,
          ).pop(); // Use root navigator

          print('🔍 After pop - route: ${Get.currentRoute}');
        });
      } catch (e) {
        print('Error saving PageFour data: $e');
        showInfoSnackbar(message: 'فشل حفظ كلمة المرور');
      }
    }

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
                  SizedBox(height: Get.height * 0.05), // 5% من ارتفاع الشاشة

                  Image.asset(
                    AppUrl.logo,
                    height: Get.height * 0.1, // 10% من ارتفاع الشاشة
                    width: Get.width * 0.3,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(height: Get.height / 8),

                  CustomTitle(
                    title: "إنشاء كلمة مرور",
                    supText: true,
                    supTitle: "(6 خانات على الأقل)",
                  ),
                  SizedBox(height: 14),

                  buildPasswordField(
                    focusNode: controller.oldPasswordFocusNode,
                    textController: controller.oldPasswordController,
                    text: "كلمة المرور القديمة",
                    onEditingComplete:
                        () => controller.handleFocusTransition(
                          controller.oldPasswordFocusNode,
                          controller.newPasswordFocusNode,
                        ),
                  ),
                  SizedBox(height: 10.h),
                  buildPasswordField(
                    focusNode: controller.newPasswordFocusNode,
                    textController: controller.newPasswordController,
                    text: "كلمة المرور الجديدة",
                    onEditingComplete:
                        () => controller.handleFocusTransition(
                          controller.newPasswordFocusNode,
                          controller.confirmPasswordFocusNode,
                        ),
                  ),
                  SizedBox(height: 10.h),

                  buildPasswordField(
                    focusNode: controller.confirmPasswordFocusNode,
                    textController: controller.confirmPasswordController,
                    text: "اعادة كلمة المرور",
                    onEditingComplete:
                        () => controller.confirmPasswordFocusNode.unfocus(),
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
                  if (password ==
                      controller.oldPasswordController.text.trim()) {
                    if (controller.newPasswordController.text.trim() ==
                        controller.confirmPasswordController.text.trim()) {
                      saveUserData();
                    }
                  } else {
                    showInfoSnackbar(message: 'كلمة السر غير صحيحة ');
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
}
