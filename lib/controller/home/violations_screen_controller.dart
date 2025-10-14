import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/data/model/violation.dart';
import 'package:nas/view/widget/button_border.dart';

class ViolationsScreenController extends GetxController {
  var violations = <Violation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchViolations();
  }

  void fetchViolations() {
    // Simulating API call or database fetch
    violations.assignAll([
      Violation(
        type: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        reason:
            "تم إلغاء الطلب بعد الموافقة عليه من قبل المسؤول. هذه المخالفة تستوجب غرامة مالية.",
      ),
      Violation(
        type: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        reason:
            "تأخر في الحضور بعد تأكيد الموعد. يرجى الالتزام بالمواعيد المحددة في المستقبل.",
      ),
      Violation(
        type: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        reason: "عدم إرسال المستندات المطلوبة في الوقت المحدد.",
      ),
      Violation(
        type: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        reason: "عدم إرسال المستندات المطلوبة في الوقت المحدد.",
      ),
    ]);
  }

  void showReason(Violation v) {
    showReasonDialog(v.reason);
  }

  void showReasonDialog(reason) {
    Get.dialog(
      Dialog(
        // Add margin to the entire Dialog
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  reason,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: Get.height * 0.026),

              ButtonBorder(
                height: Get.height * 0.04,
                borderRadius: 10,
                onTap: () => Get.back(),
                text: "إغلاق",
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
