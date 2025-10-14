import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/view/screen/Auth/forgetPassword/change_password.dart';
import 'package:nas/view/screen/Auth/forgetPassword/code_validate.dart';
import 'package:nas/view/screen/Auth/login.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

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

  sendCode() {
    print('Code sent to ${phoneController.text}');

    if (validatePhoneNumber(phoneController.text)) {
      // Simulate sending code
      print('Code sent to ${phoneController.text}');
      showSuccessSnackbar(message: 'الرمز تم إرساله بنجاح');
      Get.to(() => CodeValidate());
    } else {
      showErrorSnackbar(message: 'يرجى إدخال رقم هاتف صحيح');
    }
  }

  void verifyOtp(String code) {
    otpCode.value = code;
    print("OTP verified: $code");
    // Navigate to ChangeToNewPassword screen
  }

  goToChangePassword() {
    if (otpCode.value.isNotEmpty) {
      Get.to(() => ChangeToNewPassword());
    } else {
      showErrorSnackbar(message: 'يرجى إدخال الرمز الصحيح');
    }
  }

  void updatePassword() {
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

    // Simulate a successful password update
    showSuccessSnackbar(message: "تم تحديث كلمة المرور بنجاح");

    // Navigate to the login screen or another screen
    Get.off(() => LoginScreen()); // Replace '/login' with your login route
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
