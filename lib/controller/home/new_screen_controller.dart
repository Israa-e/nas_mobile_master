import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/data/model/job_request.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/primary_button.dart';

class NewScreenController extends GetxController {
  var jobRequests = <JobRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add sample data
    fetchJobs();
  }

  void fetchJobs() {
    // In a real app, this would come from an API
    jobRequests.value = [
      JobRequest(
        title: "مقدم طعام",
        date: "الأحد - 15/2",
        timeRange: "2:00م إلى 8:00م",
      ),
      JobRequest(
        title: "مقدم طعام",
        date: "الأحد - 15/2",
        timeRange: "2:00م إلى 8:00م",
      ),
      JobRequest(
        title: "مقدم طعام",
        date: "الأحد - 15/2",
        timeRange: "2:00م إلى 8:00م",
      ),
      JobRequest(
        title: "مقدم طعام",
        date: "الأحد - 15/2",
        timeRange: "2:00م إلى 8:00م",
      ),
    ];
  }

  void applyForJob(int index) {
    showSuccessDialog();
  }

  void showSuccessDialog() {
    Get.dialog(
      Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.5), // لون داكن شفاف
            ),
          ),
          Dialog(
            shadowColor: AppTheme.backgroundTransparent,
            // Add margin to the entire Dialog
            insetPadding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "يمكنك متابعة الطلب من خلال زر الانتظار في أسفل الصفحة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.026),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryButton(
                        onTap: () => Get.back(),
                        text: 'تأكيد',
                        height: Get.height * 0.04,
                        borderRadius: 10,

                        textColor: AppTheme.white,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 30),
                      ButtonBorder(
                        height: Get.height * 0.04,
                        borderRadius: 10,
                        onTap: () => Get.back(),
                        text: "إالغاء",

                        color: AppTheme.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  fetchJobRequests() {}
}
