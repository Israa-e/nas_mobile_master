import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

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
        maxWidth: 800, // Optimize image size
        maxHeight: 800,
        imageQuality: 85, // Reduce quality slightly for better storage
      );

      if (pickedFile != null) {
        // Get the app's local storage directory for saving images
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(
          pickedFile.path,
        ).copy('${appDir.path}/$fileName');

        print('📸 Image saved to: ${savedImage.path}');
        return savedImage.path;
      }
      return null;
    } catch (e) {
      print('❌ Error picking image: $e');
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

        showSuccessSnackbar(message: 'تم اختيار الصورة الشخصية بنجاح');
      } else {
        showInfoSnackbar(message: 'لم يتم اختيار الصورة الشخصية');
      }
    } catch (e) {
      showErrorSnackbar(message: 'فشل في اختيار صورة الهوية الشخصية');
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

  /// Save picked image paths to the user's record in the database.
  Future<bool> saveImagesToDb() async {
    try {
      final int? userId = await SharedPrefsHelper.getUserId();
      if (userId == null) {
        showErrorSnackbar(message: 'يرجى تسجيل الدخول أولاً');
        return false;
      }

      final data = getFormData();
      await DatabaseHelper.instance.updateUser(userId, data);
      showSuccessSnackbar(message: 'تم حفظ الصور بنجاح');
      return true;
    } catch (e) {
      print('❌ Error saving images to DB: $e');
      showErrorSnackbar(message: 'فشل في حفظ الصور');
      return false;
    }
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
