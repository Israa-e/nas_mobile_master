import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nas/controller/home/notification_screen_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/build_header.dart';
import 'package:nas/view/widget/build_job_card.dart';
import 'package:nas/view/widget/button_border.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller =
        Get.find<NotificationsController>();

    return Scaffold(
      backgroundColor: AppTheme.white,

      appBar: AppBar(
        leading: SizedBox(
          height: Get.height * 0.04,
          width: Get.width * 0.05,
          child: SvgPicture.asset(
            "${AppUrl.rootIcons}/notification.svg",
            height: Get.height * 0.04,
            width: Get.width * 0.05,
            fit: BoxFit.scaleDown,
          ),
        ),
        title: Image.asset(
          AppUrl.logo2,
          height: Get.height * 0.07,
          width: Get.width * 0.1,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ), // Responsive padding
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.fetchNotifications();
                },
                child: _buildJobsList(controller),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
        child: ButtonBorder(
          height: Get.height * 0.08,
          borderRadius: 15,
          onTap: () => Get.back(),
          text: "تعليم الكل كمقروق",
          color: AppTheme.primaryColor,
          textStyle: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Widget _buildJobsList(controller) {
  return Obx(
    () => ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount:
          controller.notifications.isEmpty
              ? 2
              : controller.notifications.length + 1,
      padding: EdgeInsets.zero, // Responsive padding
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildHeader(image: "notification", text: "الإشعارات");
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(
              "الإشعارات",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
        final notif = controller.notifications[index - 1];

        return buildJobCard(
          isViolation: true,
          index: index,
          type: notif.title,
          expiryDate: notif.expiryDate,
          violation: notif,
          // job: controller.violations[index],
          onTap: () => controller.showNotification(notif),
          controller: controller,
          color: notif.hasBlueHighlight ? AppTheme.blue : AppTheme.primaryColor,
          text: notif.type,
        );
      },
    ),
  );
}
