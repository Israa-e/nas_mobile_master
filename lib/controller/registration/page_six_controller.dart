import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';
import 'package:nas/data/api/api_service.dart';

class PageSixController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  final governorateController = TextEditingController();
  final districtController = TextEditingController();
  final locationController = TextEditingController();

  final nationalIdController = TextEditingController();

  final governorateFocusNode = FocusNode();
  final districtFocusNode = FocusNode();
  final locationFocusNode = FocusNode();
  final nationalIdFocusNode = FocusNode();
  final RxList<String> nationalityOptions = <String>[].obs;

  final selectedNationality = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNationalities();
  }

  Future<void> fetchNationalities() async {
    final result = await _api.getNationalities();
    nationalityOptions.assignAll(result);
    print("Loaded nationalities: $nationalityOptions"); // للتأكد من التحميل
  }

  void updateLocation(String address) {
    locationController.text = address;
  }

  Map<String, dynamic> getFormData() {
    return {
      'governorate': governorateController.text,
      'district': districtController.text,
      'location': locationController.text,
      'nationalId': nationalIdController.text,
      'nationality': selectedNationality.value,
    };
  }

  bool validate({bool showSnackbar = true}) {
    print(getFormData());
    if (governorateController.text.isEmpty ||
        districtController.text.isEmpty ||
        locationController.text.isEmpty ||
        nationalIdController.text.isEmpty ||
        selectedNationality.value.isEmpty) {
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
