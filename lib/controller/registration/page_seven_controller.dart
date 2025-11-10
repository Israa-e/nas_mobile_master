import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

class PageSevenController extends GetxController {
  final genderOptions = ['ذكر', 'أنثى'];
  final maritalStatusOptions = ['أعزب', 'متزوج'];
  final List<String> countryCodeOptions = [
    '+970',
    '+972',
    '+962',
    '+966',
    '+967',
  ];

  final RxString selectedCountryCode = '+970'.obs;
  final RxString selectedGender = ''.obs;
  final RxString selectedMaritalStatus = ''.obs;
  final TextEditingController phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();
  RxBool isPhoneSelected = false.obs;
  @override
  void onClose() {
    // Dispose of controllers and focus nodes to prevent memory leaks
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.onClose();
  }

  void setCountryCode(String? code) {
    if (code != null) {
      selectedCountryCode.value = code;
    }
  }

  void setGender(String? value) {
    selectedGender.value = value ?? '';
  }

  void setMaritalStatus(String? value) {
    selectedMaritalStatus.value = value ?? '';
  }

  bool validateForm() {
    return selectedGender.isNotEmpty &&
        selectedMaritalStatus.isNotEmpty &&
        phoneController.text.isNotEmpty;
  }

  Map<String, dynamic> getFormData() {
    return {
      'gender': selectedGender.value,
      'maritalStatus': selectedMaritalStatus.value,
      'countryCode': selectedCountryCode.value,
      'phoneNumber': phoneController.text,
      'fullPhone': '${selectedCountryCode.value}${phoneController.text}',
    };
  }

  bool validate({bool showSnackbar = true}) {
    if (!validateForm()) {
      if (showSnackbar) {
        showInfoSnackbar(message: 'الرجاء إكمال جميع الحقول المطلوبة');
      }
      return false;
    }
    return true;
  }

  // Focus management for better user experience
  void handleFocusTransition(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    nextFocus.requestFocus();
  }

  // Load user data from DB
  Future<void> loadUserData() async {
    try {
      int? userId = await SharedPrefsHelper.getUserId();
      if (userId == null) return;

      DatabaseHelper dbHelper = DatabaseHelper.instance;
      final userDetails = await dbHelper.getAllUsersById(userId);
      if (userDetails.isEmpty) return;

      final userData = userDetails[0];

      phoneController.text = userData['phone'] ?? '';
      selectedCountryCode.value = userData['countryCode'] ?? '+970';

      print(" phoneController : ${phoneController.text}");
    } catch (e) {
      print('Error loading PageFour data: $e');
    }
  }

  // Save user data to DB
  Future<void> saveUserData() async {
    try {
      int? userId = await SharedPrefsHelper.getUserId();
      if (userId == null) return;

      DatabaseHelper dbHelper = DatabaseHelper.instance;

      await dbHelper.updateUser(userId, {
        'phone': phoneController.text.trim(),
        'countryCode': selectedCountryCode.value,
      });

      showSuccessSnackbar(message: "تم تحديث رقم الهاتف");
    } catch (e) {
      print('Error saving PageFour data: $e');
      showInfoSnackbar(message: 'فشل حفظ بياناتك');
    }
  }
}
