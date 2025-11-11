import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:nas/presentation/view/screen/Auth/forgetPassword/change_password.dart';
import 'package:nas/presentation/view/screen/Auth/forgetPassword/code_validate.dart';
import 'package:nas/presentation/view/screen/Auth/login.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';

class ForgetPasswordController extends GetxController {
  // Form key for validation
  // Separate GlobalKeys for different forms
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  // Text Controllers
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final otpCode = ''.obs;
  final isOtpVerified = false.obs;
  // Focus management for better user experience
  void handleFocusTransition(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    nextFocus.requestFocus();
  }

  bool validatePhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty;
    // &&
    // RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phoneNumber);
  }

  Future<void> sendCode() async {
    print('Code sent to ${phoneController.text}');

    if (validatePhoneNumber(phoneController.text)) {
      // Simulate sending code
      print('Code sent to ${phoneController.text}');
      // Generate a 4-digit OTP and store it locally for verification
      final otp = (Random().nextInt(9000) + 1000).toString();
      await SharedPrefsHelper.setUserPhone(phoneController.text.trim());
      await SharedPrefsHelper.setForgotOtp(otp);
      // Show the OTP in a snackbar for testing/demo purposes (remove in production)
      showSuccessSnackbar(
        message: 'الرمز تم إرساله بنجاح — OTP: $otp',
        duration: const Duration(seconds: 8),
      );
      Get.to(() => CodeValidate());
    } else {
      showErrorSnackbar(message: 'يرجى إدخال رقم هاتف صحيح');
    }
  }

  void verifyOtp(String code) {
    otpCode.value = code;
    print("OTP entered: $code");
    // Compare with stored OTP
    SharedPrefsHelper.getForgotOtp()
        .then((stored) {
          if (stored != null && stored == code) {
            isOtpVerified.value = true;
            showSuccessSnackbar(message: 'تم التحقق بنجاح — OTP: $code');
            Future.delayed(const Duration(milliseconds: 500), () {
              print('🔍 About to navigate back');
              print('🔍 Get route name: ${Get.currentRoute}');

              // Try multiple methods to ensure navigation
              Get.closeAllSnackbars(); // Close snackbar

              goToChangePassword();
              print('🔍 After pop - route: ${Get.currentRoute}');
            });
          } else {
            isOtpVerified.value = false;
            showErrorSnackbar(message: 'الرمز غير صحيح');
          }
        })
        .catchError((e) {
          print('Error reading stored OTP: $e');
          showErrorSnackbar(message: 'فشل في التحقق من الرمز');
        });
  }

  goToChangePassword() {
    if (isOtpVerified.value) {
      Get.to(() => ChangeToNewPassword());
    } else if (otpCode.value.isEmpty) {
      showErrorSnackbar(message: 'يرجى إدخال الرمز أولاً');
    } else {
      showErrorSnackbar(message: 'يرجى إدخال الرمز الصحيح');
    }
  }

  Future<void> updatePassword() async {
    final password = passwordController.text.trim();
    Get.focusScope?.unfocus();

    final confirmPassword = confirmPasswordController.text.trim();
    print("password $password, confirmPassword $confirmPassword");
    if (password.isEmpty || confirmPassword.isEmpty) {
      showErrorSnackbar(message: "يرجى إدخال كلمة المرور وتأكيدها");
      return;
    }

    if (password != confirmPassword) {
      showErrorSnackbar(message: "كلمتا المرور غير متطابقتين");
      return;
    }

    // Persist the new password into the local database
    try {
      String? phone = await SharedPrefsHelper.getUserPhone();
      phone ??= phoneController.text.trim();
      if (phone.isEmpty) {
        showErrorSnackbar(message: 'يرجى إدخال رقم الهاتف المستخدم');
        return;
      }

      DatabaseHelper db = DatabaseHelper.instance;
      final user = await db.getUser(phone);
      if (user == null) {
        showErrorSnackbar(message: 'لم يتم العثور على حساب مرتبط بهذا الرقم');
        return;
      }

      final userId = user['id'] as int;
      await db.updateUser(userId, {'password': password});

      showSuccessSnackbar(
        message: "تم تحديث كلمة المرور بنجاح",
        duration: const Duration(seconds: 5),
      );
      // Navigate to the login screen
      Get.offAll(() => LoginScreen());
    } catch (e) {
      print('Error updating password: $e');
      showErrorSnackbar(message: 'فشل في تحديث كلمة المرور');
    }
  }

  @override
  void onClose() {
    print("Disposing ForgetPasswordController");
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}
