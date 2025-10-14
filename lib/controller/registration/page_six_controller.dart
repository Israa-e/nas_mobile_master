import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class PageSixController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final governorateController = TextEditingController();
  final districtController = TextEditingController();
  final locationController = TextEditingController();

  final nationalIdController = TextEditingController();

  final governorateFocusNode = FocusNode();
  final districtFocusNode = FocusNode();
  final locationFocusNode = FocusNode();
  final nationalIdFocusNode = FocusNode();

  final selectedGender = RxString('أنثى');

  List<String> genderOptions = ['ذكر', 'أنثى'];
  void updateLocation(String address) {
    locationController.text = address;
  }

  Map<String, dynamic> getFormData() {
    return {
      'governorate': governorateController.text,
      'district': districtController.text,
      'location': locationController.text,
      'nationalId': nationalIdController.text,
      'gender': selectedGender.value,
    };
  }

  bool validate({bool showSnackbar = true}) {
    print(getFormData());
    if (governorateController.text.isEmpty ||
        districtController.text.isEmpty ||
        locationController.text.isEmpty ||
        nationalIdController.text.isEmpty ||
        selectedGender.value.isEmpty) {
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

  @override
  void onClose() {
    // Dispose of controllers and focus nodes to prevent memory leaks
    governorateController.dispose();
    districtController.dispose();
    locationController.dispose();
    nationalIdController.dispose();
    governorateFocusNode.dispose();
    districtFocusNode.dispose();
    locationFocusNode.dispose();
    nationalIdFocusNode.dispose();
    super.onClose();
  }
}
