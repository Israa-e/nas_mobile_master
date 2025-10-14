import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/custom_bottom_sheet.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class PageTenController extends GetxController {
  // قائمة الشروط
  RxList<String> terms =
      <String>[
        'أوافق على شروط وقواعد العمل',
        'أوافق على قواعد السلوك المهني والأخلاقي',
        'أوافق على شروط وسياسات الخصوصية',
        'أوافق على شروط الاستخدام',
        'أوافق على التدقيق الأمني بحال طلب',
        'أوافق على إجراء فحص المخدرات بحال طلب',
        'أعترف بأنني ليس لدي أي علم بأي انتهاك أو انتهاك محتمل لهذه الشفرة. وأنا أفهم أن انتهاك أي من هذه المدونات قد يؤدي إلى اتخاذ إجراءات تأديبية، قد تشمل إنهاء الخدمة والإجراءات القانونية. وعليه أبرئ ذمة (ناس لتكنلوجيا المعلومات) إبراءً عاماً شاملاً حاضرً ومستقبلا من أي مطالبة أو تبعات ناتجة عن أي تقصير من قبلي أو نقص في فهمها، ويتم اعتبار موافقتي على هذا النموذج بمثابة توقيعي الشخصي على جميع ما ذكر.',
      ].obs;

  RxList<bool> selectedTerms = <bool>[].obs;
  // Get underlined text spans for specific terms
  List<TextSpan> getUnderlinedTextSpans(String text, int index) {
    Map<String, String> underlinedParts = {
      'أوافق على شروط وقواعد العمل': 'شروط وقواعد العمل',
      'أوافق على قواعد السلوك المهني والأخلاقي':
          'قواعد السلوك المهني والأخلاقي',
      'أوافق على شروط وسياسات الخصوصية': 'شروط وسياسات الخصوصية',
      'أوافق على شروط الاستخدام': 'شروط الاستخدام',
    };

    if (underlinedParts.containsKey(text)) {
      return [
        TextSpan(text: "أوافق على "),
        TextSpan(
          text: underlinedParts[text],
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 2,
            color: AppTheme.white,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  Get.bottomSheet(
                    CustomBottomSheet(
                      title: underlinedParts[text] ?? '',
                      documentType: text,
                      termIndex: index, // ⬅️ نمرر الفهرس هنا
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    enableDrag: true,
                  );
                },
        ),
      ];
    }

    // Default case if text doesn't match any of the above
    return [TextSpan(text: text)];
  }

  // قائمة للتحقق من تحديد كل شرط
  @override
  void onInit() {
    super.onInit();
    // Initialize selectedTerms list with false (unselected) for each term
    selectedTerms.value = List.generate(terms.length, (index) => false);
  }

  // تغيير حالة الموافقة على شرط معين
  void toggleTerm(int index) {
    selectedTerms[index] = !selectedTerms[index];
    selectedTerms.refresh(); // Refresh to notify listeners
  }

  // Toggle selection of a term
  void toggleSelection(int index) {
    selectedTerms[index] = !selectedTerms[index];
    selectedTerms.refresh(); // Refresh to notify listeners
  }

  // التحقق من الموافقة على جميع الشروط
  bool get areAllTermsAccepted => selectedTerms.every((accepted) => accepted);

  Map<String, dynamic> getFormData() {
    Map<String, bool> acceptedTerms = {};
    for (int i = 0; i < terms.length; i++) {
      acceptedTerms[terms[i]] = selectedTerms[i];
    }

    return {
      'allTermsAccepted': areAllTermsAccepted,
      'acceptedTerms': acceptedTerms,
    };
  }

  bool validate({bool showSnackbar = true}) {
    if (!areAllTermsAccepted) {
      if (showSnackbar) {
        showInfoSnackbar(message: 'الرجاء الموافقة على جميع الشروط والأحكام');
      }
      return false;
    }
    return true;
  }
}
