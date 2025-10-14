import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/screen/Auth/forgetPassword/forget_password.dart';
import 'package:nas/view/screen/Auth/worker_registration_screen.dart';
import 'package:nas/view/screen/main/main_home_screen.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_snackbar.dart';
import 'package:nas/view/widget/primary_button.dart';
import 'package:nas/data/fcm_api.dart';

import 'worker_registration_controller.dart';

class LoginController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  bool rememberMe = false;
  final FCMApi fcmApi = FCMApi(); // Initialize FCMApi instance
  @override
  void onInit() {
    super.onInit();
    // Initialize FCM when controller is created
    initializeFCM();
  }
  // Initialize FCM
  Future<void> initializeFCM() async {
    try {
      await fcmApi.initNotification();
      print('FCM initialized successfully');
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }
  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    update();
  }

  // Login method
  void login()async {
    try {
      Get.focusScope!.unfocus(); // Close the keyboard

      if (formstate.currentState != null &&
          formstate.currentState!.validate()) {

        // Show loading indicator
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        // Simulate API call or authentication logic
        await Future.delayed(Duration(seconds: 1)); // Simulating network delay

        // Make sure FCM is initialized and get token
        final token = await fcmApi.firebaseMessaging.getToken();
        print('FCM Token: $token');

        // Here you would typically send the token to your backend
        // await userRepository.updateFcmToken(token);

        // Subscribe to relevant topics based on user role
        await fcmApi.subscribeToTopic('all_users');

        // If user is in specific groups, subscribe to those topics
        // Example: await fcmApi.subscribeToTopic('workers');

        // Close loading dialog
        Get.back();

        showSuccessSnackbar();
        print('Login successful');
        Get.offAll(() => MainHomeScreen());
      } else {
        print('Validation failed');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      showErrorSnackbar(message: e.toString());
    }
  }

  // Forgot password method
  void forgotPassword() {
    // Implement forgot password logic
    Get.focusScope?.unfocus(); // Close the keyboard
    Get.to(() => ForgetPassword());
    print('Forgot password tapped');
  }

  // Join work method
  void joinWork() {
    // Implement join work logic
    Get.focusScope?.unfocus(); // Close the keyboard
    Get.delete<
      WorkerRegistrationController
    >(); // Remove the controller if it exists
    Get.to(
      () => WorkerRegistrationScreen(),
    ); // Navigate to the worker registration screen
  }

  // Need help method
  void needHelp() async {
    // Implement help logic
    await FCMApi().initNotification();

    Get.focusScope?.unfocus();
    needHelpDialog();
  }

  @override
  void onClose() {
    print("Disposing ForgetPasswordController");

    phoneController.dispose();
    passwordController.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  // Focus management for better user experience
  void handleFocusTransition(FocusNode currentFocus, FocusNode nextFocus) {
    if (currentFocus.hasFocus) currentFocus.unfocus();
    if (nextFocus.canRequestFocus) nextFocus.requestFocus();
  }

  void needHelpDialog() {
    Get.dialog(
      Dialog(
        // Add margin to the entire Dialog
        insetPadding: EdgeInsets.symmetric(horizontal: 30),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            // height: 183,
            color: AppTheme.white,
            padding: EdgeInsets.symmetric(horizontal: 29, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  "قم بكتابة سؤالك وسيتم الرد عليك قريبا",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryButton(
                      onTap: () {
                        Get.back();
                        showSuccessDialog();
                      },
                      text: "إرسال",
                      height: Get.height * 0.04,
                      borderRadius: 10,

                      textColor: AppTheme.white,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 30),
                    ButtonBorder(
                      height: Get.height * 0.04,
                      borderRadius: 10,
                      onTap: () => Get.back(),
                      text: "إغلاق",
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        // Add margin to the entire Dialog
        insetPadding: EdgeInsets.symmetric(horizontal: 68),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            // height: 183,
            color: AppTheme.white,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  "تم ارسال طلبك بنجاح سوف نقوم بمراجعة الطلب والرد عليك في أقرب وقت ممكن ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),

                ButtonBorder(
                  height: 30,
                  borderRadius: 10,

                  onTap: () {
                    Get.back();
                  },
                  text: "إغلاق",
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  // Method to send a test notification
  Future<void> sendTestNotification() async {
    try {
      // Create a sample notification for testing
      final message = {
        'notification': {
          'title': 'مرحباً',
          'body': 'تم تسجيل الدخول بنجاح!'
        },
        'data': {
          'screen': 'home',
          'item_id': 'welcome'
        }
      };

      // Show local notification
      fcmApi.showTestLocalNotification(  title: 'تنبيه',
          body: 'هذا إشعار محلي تجريبي!',
          data: {'screen': 'home', 'item_id': '123'});
      print('Test notification sent');
    } catch (e) {
      print('Error sending test notification: $e');
    }
  }
}
