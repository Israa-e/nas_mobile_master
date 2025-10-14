import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/home/violations_screen_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/build_header.dart';
import 'package:nas/view/widget/build_job_card.dart';

class ViolationsScreen extends StatelessWidget {
  const ViolationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ViolationsScreenController controller =
        Get.find<ViolationsScreenController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            buildHeader(image: "violations", text: "المخالفات"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.fetchViolations();
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
        controller.violations.isEmpty
            ? Center(
              child: Text(
                'لا توجد مخالفات ',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
            : ListView.builder(
              itemCount: controller.violations.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return buildJobCard(
                  isViolation: true,
                  index: index,
                  violation: controller.violations[index],
                  expiryDate: controller.violations[index].expiryDate,

                  type: controller.violations[index].type,
                  // job: controller.violations[index],
                  onTap:
                      () => controller.showReason(controller.violations[index]),
                  controller: controller,
                  color: AppTheme.red,
                  text: "السبب",
                );
              },
            ),
  );
}
