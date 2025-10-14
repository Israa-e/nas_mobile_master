import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class PageNineController extends GetxController {
  // First Contact Person
  final TextEditingController firstNameController = TextEditingController();
  final RxString firstRelationType = RxString('');
  final TextEditingController firstPhoneController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final firstPhoneFocusNode = FocusNode();

  // Second Contact Person
  final TextEditingController secondNameController = TextEditingController();
  final RxString secondRelationType = RxString('');
  final TextEditingController secondPhoneController = TextEditingController();
  final secondNameFocusNode = FocusNode();
  final secondPhoneFocusNode = FocusNode();

  // Relation type options
  final List<String> relationTypes = [
    'أب',
    'أم',
    'أخ',
    'أخت',
    'زوج',
    'زوجة',
    'صديق',
    'أخرى',
  ];

  final List<String> countryCodeOptions = [
    '+970',
    '+972',
    '+962',
    '+966',
    '+967',
  ];
  final RxString selectedCountryCode = '+970'.obs;
  void setCountryCode(String? code) {
    if (code != null) {
      selectedCountryCode.value = code;
    }
  }

  bool _validateContactInfo() {
    return firstNameController.text.isNotEmpty &&
        firstRelationType.value.isNotEmpty &&
        firstPhoneController.text.isNotEmpty &&
        secondNameController.text.isNotEmpty &&
        secondRelationType.value.isNotEmpty &&
        secondPhoneController.text.isNotEmpty;
  }

  Map<String, dynamic> getFormData() {
    return {
      'firstContact': {
        'name': firstNameController.text,
        'relationType': firstRelationType.value,
        'phone': firstPhoneController.text,
        'fullPhone': '${selectedCountryCode.value}${firstPhoneController.text}',
      },
      'secondContact': {
        'name': secondNameController.text,
        'relationType': secondRelationType.value,
        'phone': secondPhoneController.text,
        'fullPhone':
            '${selectedCountryCode.value}${secondPhoneController.text}',
      },
    };
  }

  bool validate({bool showSnackbar = true}) {
    if (!_validateContactInfo()) {
      if (showSnackbar) {
        showInfoSnackbar(
          message: 'الرجاء إدخال معلومات جهات الاتصال بشكل كامل',
        );
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

  @override
  void onClose() {
    // Dispose of controllers and focus nodes to prevent memory leaks
    firstNameController.dispose();
    firstPhoneController.dispose();
    secondNameController.dispose();
    secondPhoneController.dispose();
    firstNameFocusNode.dispose();
    firstPhoneFocusNode.dispose();
    secondNameFocusNode.dispose();
    secondPhoneFocusNode.dispose();
    super.onClose();
  }
}
