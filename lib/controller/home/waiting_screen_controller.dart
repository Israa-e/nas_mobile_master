import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/data/model/job_request.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

class WaitingScreenController extends GetxController {
  var pendingRequests = <JobRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  void fetchPendingRequests() {
    // In a real app, this would come from an API
    pendingRequests.value = [
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

  void cancelRequest(int index) {
    showDeleteDialog(index);
  }

  void showDeleteDialog(index) {
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "تم إرسال طلبك للعميل \nيمكن أن تؤدي عملية الإلغاء إلى خفض درجاتك أو حظرك عن العمل",
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
                        ButtonBorder(
                          height: Get.height * 0.04,
                          borderRadius: 10,
                          onTap: () {
                            pendingRequests.removeAt(index);
                            Get.back();
                            showSuccessSnackbar(
                              message: 'تم إلغاء الطلب بنجاح',
                            );
                          },
                          text: 'تأكيد',
                          color: AppTheme.red,
                        ),
                        SizedBox(width: 30),
                        ButtonBorder(
                          height: Get.height * 0.04,
                          borderRadius: 10,
                          onTap: () => Get.back(),
                          text: "إغلاق",
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
