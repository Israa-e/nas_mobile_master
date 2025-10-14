import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/home/waiting_screen_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/build_header.dart';
import 'package:nas/view/widget/build_job_card.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WaitingScreenController controller =
        Get.find<WaitingScreenController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            buildHeader(image: "wait", text: "طلبات قيد الإنتظار"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.fetchPendingRequests();
                },
                child: _buildJobsList(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildJobsList(controller) {
  return Obx(
    () =>
        controller.pendingRequests.isEmpty
            ? Center(
              child: Text(
                'لا توجد طلبات للموافقة',
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
            )
            : ListView.builder(
              itemCount: controller.pendingRequests.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildJobCard(
                  index: index,
                  onTap: () => controller.cancelRequest(index),

                  color: AppTheme.red,
                  job: controller.pendingRequests[index],
                  controller: controller,
                  text: "إلغاء",
                );
              },
            ),
  );
}
