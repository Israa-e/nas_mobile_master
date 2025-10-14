import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class PageOneController extends GetxController {
  final sources = [
    'فيسبوك',
    'انستغرام',
    "لنكدان",
    'السوق المفتوح',
    'موقع ناس الكتروني',
  ];

  final selectedSource = ''.obs;
  final otherSourceController = TextEditingController();
  final isOtherSelected = false.obs;
  final otherFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    otherFocusNode.addListener(() {
      if (otherFocusNode.hasFocus) {
        selectOther();
      }
    });
  }

  void selectSource(String source, BuildContext context) {
    FocusScope.of(context).unfocus();

    selectedSource.value = source;
    isOtherSelected.value = false;
    otherSourceController
        .clear(); // Clear "Other" input when a predefined source is selected
  }

  void selectOther() {
    selectedSource.value = '';
    isOtherSelected.value = true;
    if (isOtherSelected.value) {
      otherFocusNode.requestFocus();
    } else {
      otherFocusNode.unfocus();
    }
    update();
  }

  Map<String, dynamic> getFormData() {
    return {
      'source':
          isOtherSelected.value
              ? otherSourceController.text
              : selectedSource.value,
      'isOtherSource': isOtherSelected.value,
    };
  }

  bool validate({bool showSnackbar = true}) {
    final source =
        isOtherSelected.value
            ? otherSourceController.text
            : selectedSource.value;

    if (source.isEmpty) {
      if (showSnackbar) {
        showInfoSnackbar(message: 'الرجاء اختيار مصدر');
      }
      return false;
    }
    return true;
  }

  bool hasInputData() {
    return selectedSource.value.isNotEmpty ||
        otherSourceController.text.isNotEmpty;
  }

  @override
  void onClose() {
    otherSourceController.dispose();
    otherFocusNode.dispose(); // Dispose the FocusNode

    super.onClose();
  }
}
