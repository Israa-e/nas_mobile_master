import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class PageFourController extends GetxController {
  final RxSet<String> selectedWorkHours = <String>{}.obs;

  final List<String> workHourOptions = [
    '6 ساعات او اقل',
    'من 6 الى 9 ساعات',
    'من 9 الى 12 ساعة',
  ];

  final List<String> workHourPrices = ['10 دينار', '15 دينار', '20 دينار'];
  List<TextSpan> getUnderlinedTextSpans(String text) {
    // Manually define which parts should be underlined based on your specific texts
    if (text == '6 ساعات او اقل') {
      return [
        TextSpan(
          text: '6',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            fontSize: 18,
          ),
        ),
        TextSpan(text: ' ساعات او اقل'),
      ];
    } else if (text == 'من 6 الى 9 ساعات') {
      return [
        TextSpan(text: 'من '),
        TextSpan(
          text: '6',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.white,
          ),
        ),
        TextSpan(text: ' الى '),
        TextSpan(
          text: '9',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.white,
            decoration: TextDecoration.underline,
            decorationThickness: 1,
          ),
        ),
        TextSpan(text: ' ساعات'),
      ];
    } else if (text == 'من 9 الى 12 ساعة') {
      return [
        TextSpan(text: 'من '),
        TextSpan(
          text: '9',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.white,
          ),
        ),
        TextSpan(text: ' الى '),
        TextSpan(
          text: '12',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.white,
          ),
        ),
        TextSpan(text: ' ساعة'),
      ];
    }
    // Default case with no underline
    return [TextSpan(text: text)];
  }

  // Simple helper method for prices
  List<TextSpan> getUnderlinedPriceSpans(String price) {
    // Extract number and "دينار" parts
    if (price == '10 دينار') {
      return [
        TextSpan(
          text: '10',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextSpan(text: ' دينار'),
      ];
    } else if (price == '15 دينار') {
      return [
        TextSpan(
          text: '15',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            fontSize: 18,
          ),
        ),
        TextSpan(text: ' دينار'),
      ];
    } else if (price == '20 دينار') {
      return [
        TextSpan(
          text: '20',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextSpan(text: ' دينار'),
      ];
    }
    // Default case with no underline
    return [TextSpan(text: price)];
  }

  void toggleWorkHour(String workHour) {
    if (selectedWorkHours.contains(workHour)) {
      selectedWorkHours.remove(workHour);
    } else {
      selectedWorkHours.clear(); // Ensure only one selection
      selectedWorkHours.add(workHour);
    }
  }

  final accountNameController = TextEditingController();
  final departmentNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final FocusNode accountNameFocusNode = FocusNode();
  final FocusNode departmentNameFocusNode = FocusNode();
  final FocusNode accountNumberFocusNode = FocusNode();

  @override
  void onClose() {
    accountNameController.dispose();
    accountNumberController.dispose();
    departmentNameController.dispose();

    super.onClose();
  }

  bool get isFormValid =>
      selectedWorkHours.isNotEmpty &&
      accountNameController.text.isNotEmpty &&
      departmentNameController.text.isNotEmpty &&
      accountNumberController.text.isNotEmpty;
  Map<String, dynamic> getFormData() {
    return {
      'workHours': selectedWorkHours.toList(),
      'accountName': accountNameController.text,
      'departmentName': departmentNameController.text,
      'accountNumber': accountNumberController.text,
    };
  }

  bool validate({bool showSnackbar = true}) {
    if (!isFormValid) {
      if (showSnackbar) {
        showInfoSnackbar(message: 'الرجاء إكمال جميع الحقول المطلوبة');
      }
      return false;
    }
    return true;
  }

  void handleFocusTransition(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    nextFocus.requestFocus();
  }
}
