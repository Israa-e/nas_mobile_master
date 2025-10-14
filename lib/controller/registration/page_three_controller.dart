import 'package:get/get.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

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
      'selectedDays': selectedDays.toList(),
      'selectedTimes': selectedTimes.toList(),
    };
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
