import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class PageEightController extends GetxController {
  final RxString selectedFrontIDImage = 'c'.obs;
  final RxString selectedBackIDImage = 'c'.obs;
  final RxString selectedPersonalImage = 'c'.obs;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final newPasswordFocusNode = FocusNode();
  final oldPasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  RxBool isNewPasswordSelected = false.obs;
  RxBool isConfirmPasswordSelected = false.obs;

  @override
  void onClose() {
    // Dispose of controllers and focus nodes to prevent memory leaks
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  Future<String?> pickImage() async {
    try {
      // Use an image picker package like `image_picker` to select an image
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      return pickedFile
          ?.path; // Return the image path or null if no image is selected
    } catch (e) {
      showErrorSnackbar(message: 'فشل في اختيار الصورة');
      return null;
    }
  }

  void selectPersonalImage() async {
    try {
      // Implement image selection logic
      final String? pickedImagePath = await pickImage();
      if (pickedImagePath != null) {
        selectedPersonalImage.value = pickedImagePath;
        Get.snackbar(
          'نجاح',
          'تم اختيار الصورة الشخصية بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'تنبيه',
          'لم يتم اختيار الصورة الشخصية',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to select personal image');
    }
  }

  void selectFrontIDImage() async {
    try {
      // Implement image selection logic
      final String? pickedImagePath = await pickImage();
      if (pickedImagePath != null) {
        selectedFrontIDImage.value = pickedImagePath;
        showSuccessSnackbar(message: 'تم اختيار صورة الهوية الأمامية بنجاح');
      } else {
        showInfoSnackbar(message: 'لم يتم اختيار صورة الهوية الأمامية');
      }
    } catch (e) {
      showErrorSnackbar(message: 'فشل في اختيار صورة الهوية الأمامية');
    }
  }

  void selectBackIDImage() async {
    try {
      // Simulate image selection logic (e.g., using an image picker package)
      // Example: Use a file picker or image picker to select an image
      final String? pickedImagePath =
          await pickImage(); // Replace with your image picker logic

      if (pickedImagePath != null) {
        selectedBackIDImage.value = pickedImagePath;
        showSuccessSnackbar(message: 'تم اختيار صورة الهوية الخلفية بنجاح');
      } else {
        showInfoSnackbar(message: 'لم يتم اختيار صورة الهوية الخلفية');
      }
    } catch (e) {
      showErrorSnackbar(message: 'فشل في اختيار صورة الهوية الخلفية');
    }
  }

  bool validatePassword() {
    return newPasswordController.text == confirmPasswordController.text &&
        newPasswordController.text.length >= 6;
  }

  Map<String, dynamic> getFormData() {
    return {
      'frontIdImage': selectedFrontIDImage.value,
      'backIdImage': selectedBackIDImage.value,
      'personalImage': selectedPersonalImage.value,
      'password': newPasswordController.text,
    };
  }

  bool validate({bool showSnackbar = true}) {
    if (
    // selectedFrontIDImage.value.isEmpty ||
    //   selectedBackIDImage.value.isEmpty ||
    //   selectedPersonalImage.value.isEmpty ||
    !validatePassword()) {
      if (showSnackbar) {
        showInfoSnackbar(
          message: 'الرجاء تحميل جميع الصور وإدخال كلمة مرور صالحة',
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
}
