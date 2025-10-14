import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/data/fcm_api.dart';
import 'package:nas/firebase_options.dart';
import 'package:nas/view/screen/Auth/login.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    _initializeApp();
    super.onInit();
  }

  Future<void> _initializeApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {

        await Future.delayed(const Duration(seconds: 4));

        // الانتقال إلى صفحة تسجيل الدخول
        Get.offAll(() => LoginScreen());
      } catch (e) {
        print('حدث خطأ أثناء التهيئة: $e');
        // بإمكانك عرض شاشة خطأ هنا مثلاً
      }
    });
  }

  @override
  void onClose() {
    // Cleanup if needed
    super.onClose();
  }
}
