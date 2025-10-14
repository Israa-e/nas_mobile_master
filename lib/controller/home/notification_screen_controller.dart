import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/data/model/notification_item.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

import '../../core/constant/theme.dart';

class NotificationsController extends GetxController {
  var notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    // Simulating API call or database fetch
    notifications.assignAll([
      NotificationItem(
        title: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        type: "تعليم كمقروء",
        hasBlueHighlight: true,
        detail: "تم إلغاء الطلب بعد الموافقة عليه، يرجى مراجعة القسم المختص",
      ),
      NotificationItem(
        title: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        type: "قراءة",
        detail:
            "نشكرك على التزامك بالمواعيد المحددة، نرجو منك الاطلاع على التفاصيل",
      ),
      NotificationItem(
        title: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        type: "قراءة",
        detail:
            "هناك تحديث على طلبك الأخير، يرجى مراجعة حالة الطلب في لوحة التحكم",
      ),
      NotificationItem(
        title: "الإلغاء بعد الموافقة",
        expiryDate: "15/3/2025",
        type: "تعليم كمقروء",
        hasBlueHighlight: true,
        detail:
            "تم تحديث حالة طلبك إلى 'معلق'، نرجو منك استكمال البيانات المطلوبة",
      ),
    ]);
  }

  void markAllAsRead() {
    // Logic to mark all notifications as read
    showSuccessSnackbar(message: 'تم تعليم جميع الإشعارات كمقروءة');
  }

  void showNotification(NotificationItem v) {
    showNotificationDialog(v.detail);
  }

  void showNotificationDialog(reason) {
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
            // Add margin to the entire Dialog
            insetPadding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    reason,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Get.height * 0.04),

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
        ],
      ),
      barrierDismissible: false,
    );
  }
}
