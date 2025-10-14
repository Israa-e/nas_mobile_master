import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/custom_bottom_sheet.dart';

import 'package:nas/view/widget/custom_snackbar.dart';

class PageTwoController extends GetxController {
  RxList<bool> selectedTasks = <bool>[].obs;
  RxList<int> selectedWithQuestion = <int>[].obs;
  RxBool showDrinkQuestion = false.obs; // متغير يظهر سؤال الكحول
  RxBool acceptAlcohol =
      false.obs; // لتخزين إذا كان المستخدم يقبل تقديم الكحول أم لا
  RxList<bool?> taskAnswers =
      List.generate(6, (_) => false).obs; // Initially null for all tasks
  final selectedSource = ''.obs;

  final List<String> tasks = [
    'مقدم طعام وشراب',
    'مساعد طاهي',
    'منظف غرف',
    'منظف مرافق',
    'نظافة وجلي المطبخ',
    'تحميل وتنزيل',
  ];
  final List<String> taskQuestions = [
    'هل يمكنك تقديم الكحول في حال قبوله؟',
    'هل لديك خبرة في تقطيع الخضار؟',
    'هل تستطيع ترتيب الأسرّة بسرعة؟',
    'هل لديك خبرة في تنظيف الحمامات؟',
    'هل تلتزم بمعايير النظافة الصحية؟',
    'هل تستطيع رفع أوزان ثقيلة؟',
  ];

  void taskSelectionController() {
    // Initialize with false for each task
    selectedTasks.value = List.generate(tasks.length, (index) => false);
  }

  @override
  void onInit() {
    super.onInit();
    taskSelectionController(); // تهيئة القيم عند البداية
  }

  bool rememberMe = false;

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    update();
  }

  void toggleTask(int index) {
    if (index >= 0 && index < selectedTasks.length) {
      selectedTasks[index] = !selectedTasks[index];
      selectedTasks.refresh(); // Notify listeners of the change

      // Update the question visibility if task is "مقدم طعام وشراب"
      if (tasks[index] == 'مقدم طعام وشراب') {
        showDrinkQuestion.value = selectedTasks[index];
      }

      // Update selectedWithQuestion based on task selection
      if (selectedTasks[index]) {
        selectedWithQuestion.add(index);
      } else {
        selectedWithQuestion.remove(index);
      }

      selectedWithQuestion.refresh();
    }
  }

  bool get isAnyTaskSelected => selectedTasks.any((task) => task == true);
  // Retrieve form data
  Map<String, dynamic> getFormData() {
    List<String> selectedTaskNames =
        tasks
            .asMap()
            .entries
            .where((entry) => selectedTasks[entry.key])
            .map((entry) => entry.value)
            .toList();

    return {
      'selectedTasks': selectedTaskNames,
      'rememberMe': rememberMe,
      'acceptAlcohol': showDrinkQuestion.value ? acceptAlcohol.value : null,
    };
  }

  bool validate({bool showSnackbar = true}) {
    if (isAnyTaskSelected == false) {
      if (showSnackbar) {
        showInfoSnackbar(message: 'الرجاء اختيار مهمة واحدة على الأقل');
      }
      if (showDrinkQuestion.value && !acceptAlcohol.value) {
        if (showSnackbar) {
          showInfoSnackbar(message: 'الرجاء تحديد إذا كنت تقبل تقديم الكحول');
        }
        return false;
      }
      return false;
    }
    return true;
  }

  void setTaskAnswer(int index, bool value) {
    taskAnswers[index] = value; // Update the answer for the task
    taskAnswers.refresh(); // Refresh to update the UI
  }

  void showSuccessDialog(int index) {
    Get.bottomSheet(
      CustomBottomSheet(
        title: tasks[index],
        documentType: '''
سياسة : السلامة هي محور إهتمامنا الأولقاعدة العمل: يجب على الأفراد إرتداء خوذة عند تواجدهم في موقع البناء.يجب على المفتشين القيام بدورات تفتيشية أسبوعية على مواقع البناء والتأكد من استيفاء اشتراطات السلامة.إذا تعطلت آلة تكسير الخرسانة في الموقع فيجب تبديلها خلال 4 ساعات من العطل.سياسة: نحرص على أن نقوم بأعمال الصيانة بطريقة تزيد من عمر الأجهزة وفعاليتهاقاعدة العمل: إذا مر عام على تسليم الأجهزة لفريق العمل فيجب على فني الصيانة مراجعة الأجهزة المسلمة للفريق والتأكد من أن لا تقل سرعتها عن...
كما نرى قواعد العمل مكتوبة على مستوى تشغيلي محدد يمكن قياسه واختباره.
لماذا نضيع الوقت في كتابة سياسات تبدو عامة وتحتاج دائماً إلى تفسير؟ لماذا لا نكتب قواعد العمل مباشرة؟
السياسات المكتوبة بشكل جيد تحرر وقت القيادات من الإنشغال بالمواقف التشغيلية التي يمكن أن يعالجها الموظفات والموظفين بشيء من الحرية والسرعة التي يتطلبها الموقف التشغيلي دون إشراك القيادات، السياسات المكتوبة بشكل جيد توضح حدود الموظفات والموظفين في اتخاذ القرار وتمنحهم قدر جيد من الحرية لتغيير قواعد عملهم بما يتناسب مع الإحتياجات المتغيرة للعمليات التشغيلية.''',
        termIndex: index, // ⬅️ نمرر الفهرس هنا
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      enableDrag: true,
    );
  }
}
