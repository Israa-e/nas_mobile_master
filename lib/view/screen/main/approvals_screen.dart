import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/home/approvals_screen_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/build_header.dart';
import 'package:nas/view/widget/build_job_card.dart';

class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApprovalsScreenController controller =
        Get.find<ApprovalsScreenController>();
    return Scaffold(
      backgroundColor: AppTheme.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            buildHeader(image: "accept", text: "طلبات موافق عليها"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.fetchApprovals();
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
        controller.approvalsList.isEmpty
            ? Center(
              child: Text(
                'لا توجد طلبات للموافقة',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
            : ListView.builder(
              itemCount: controller.approvalsList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return buildJobCard(
                  index: index,
                  job: controller.approvalsList[index],
                  controller: controller,
                  widget: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.approveRequest(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'الموقع',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.removeRequest(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
  );
}
