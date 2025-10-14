import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class PageFiveController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final grandFatherNameController = TextEditingController();
  final familyNameController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final fatherNameFocusNode = FocusNode();
  final grandFatherNameFocusNode = FocusNode();
  final familyNameFocusNode = FocusNode();

  // Date Selection
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Lists for Dropdown Selections
  final List<String> days = List.generate(
    31,
    (index) => (index + 1).toString(),
  );
  final List<String> months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  final List<String> years = List.generate(
    100,
    (index) => (DateTime.now().year - index).toString(),
  );

  // Selected Dropdown Values - initialize with default values
  final RxString selectedDay = RxString('1'); // Default to first day
  final RxString selectedMonth = RxString('يناير'); // Default to first month
  final RxString selectedYear = RxString(
    DateTime.now().year.toString(),
  ); // Default to current year
  @override
  void onInit() {
    super.onInit();
    // Set initial date when controller is initialized
    updateDate();
  }

  void updateDate() {
    try {
      if (selectedDay.isNotEmpty &&
          selectedMonth.isNotEmpty &&
          selectedYear.isNotEmpty) {
        final monthIndex = months.indexOf(selectedMonth.value);
        if (monthIndex >= 0) {
          int day = int.parse(selectedDay.value);
          int year = int.parse(selectedYear.value);
          int month = monthIndex + 1;

          // Adjust days for the selected month and year
          int daysInMonth = DateTime(year, month + 1, 0).day;
          if (day > daysInMonth) {
            selectedDay.value = daysInMonth.toString();
            day = daysInMonth;
          }

          selectedDate.value = DateTime(year, month, day);
        }
      }
    } catch (e) {
      selectedDate.value = null;
    }
  }

  // Adjust available days based on selected month and year
  List<String> getAvailableDays() {
    try {
      final monthIndex = months.indexOf(selectedMonth.value);
      final year = int.parse(selectedYear.value);
      final daysInMonth = DateTime(year, monthIndex + 2, 0).day;
      return List.generate(daysInMonth, (index) => (index + 1).toString());
    } catch (e) {
      return days;
    }
  }

  Map<String, dynamic> getFormData() {
    return {
      'firstName': firstNameController.text,
      'fatherName': fatherNameController.text,
      'grandFatherName': grandFatherNameController.text,
      'familyName': familyNameController.text,
      'birthDate': selectedDate.value?.toString(),
      'birthDay': selectedDay.value,
      'birthMonth': selectedMonth.value,
      'birthYear': selectedYear.value,
    };
  }

  bool validate({bool showSnackbar = true}) {
    if (firstNameController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        grandFatherNameController.text.isEmpty ||
        familyNameController.text.isEmpty ||
        selectedDate.value == null) {
      if (showSnackbar) {
        showInfoSnackbar(
          message: 'الرجاء إكمال جميع حقول الاسم وتاريخ الميلاد',
        );
      }
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    // Dispose of controllers and focus nodes to prevent memory leaks
    firstNameController.dispose();
    fatherNameController.dispose();
    grandFatherNameController.dispose();
    familyNameController.dispose();
    firstNameFocusNode.dispose();
    fatherNameFocusNode.dispose();
    grandFatherNameFocusNode.dispose();
    familyNameFocusNode.dispose();
    super.onClose();
  }
}
