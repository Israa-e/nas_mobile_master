import 'dart:convert';

import 'package:get/get.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

class PageThreeController extends GetxController {
  final RxSet<String> selectedDays = <String>{}.obs;

  // Change to RxSet to store multiple selected times
  final RxSet<String> selectedTimes = <String>{}.obs;

  final List<String> days = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  final List<String> times = ['الصباح', 'المساء', 'الليل'];

  void toggleDay(String day) {
    selectedDays.contains(day)
        ? selectedDays.remove(day)
        : selectedDays.add(day);
  }

  void toggleTime(String time) {
    selectedTimes.contains(time)
        ? selectedTimes.remove(time)
        : selectedTimes.add(time);
  }

  bool get isFormValid => selectedDays.isNotEmpty && selectedTimes.isNotEmpty;
  Map<String, dynamic> getFormData() {
    return {
      'favouriteDays': selectedDays.toList(),
      'favouriteTimes': selectedTimes.toList(),
    };
  }

  // Load data from DB
  Future<void> loadUserData() async {
    try {
      int? userId = await SharedPrefsHelper.getUserId();
      if (userId == null) return;

      DatabaseHelper dbHelper = DatabaseHelper.instance;
      final userDetails = await dbHelper.getAllUsersById(userId);
      if (userDetails.isEmpty) return;

      final userData = userDetails[0];

      final daysList = List<String>.from(
        jsonDecode(userData['favouriteDays'] ?? '[]'),
      );
      selectedDays.addAll(daysList);

      final timesList = List<String>.from(
        jsonDecode(userData['favouriteTimes'] ?? '[]'),
      );
      selectedTimes.addAll(timesList);
    } catch (e) {
      print('Error loading PageThree data: $e');
    }
  }

  // Save data to DB
  Future<void> saveUserData() async {
    try {
      int? userId = await SharedPrefsHelper.getUserId();
      if (userId == null) return;

      DatabaseHelper dbHelper = DatabaseHelper.instance;

      await dbHelper.updateUser(userId, {
        'favouriteDays': jsonEncode(selectedDays.toList()),
        'favouriteTimes': jsonEncode(selectedTimes.toList()),
      });

      showSuccessSnackbar(message: 'تم حفظ أيامك وفتراتك بنجاح');
    } catch (e) {
      print('Error saving PageThree data: $e');
      showInfoSnackbar(message: 'فشل حفظ أيامك وفتراتك');
    }
  }

  // Add this validate method
  bool validate({bool showSnackbar = true}) {
    if (!isFormValid) {
      if (showSnackbar) {
        showInfoSnackbar(
          message: 'الرجاء اختيار يوم وفترة زمنية واحدة على الأقل',
        );
      }
      return false;
    }
    return true;
  }
}
