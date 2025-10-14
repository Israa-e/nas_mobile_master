import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/home/new_screen_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/widget/build_header.dart';
import 'package:nas/view/widget/build_job_card.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewScreenController controller = Get.find<NewScreenController>();

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            buildHeader(image: 'new', text: "طلبات جديدة"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchJobRequests();
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
        controller.jobRequests.isEmpty
            ? Center(
              child: Text(
                'لا توجد طلبات للموافقة',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
            : ListView.builder(
              itemCount: controller.jobRequests.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildJobCard(
                  index: index,
                  onTap: () => controller.applyForJob(index),

                  job: controller.jobRequests[index],
                  controller: controller,
                );
              },
            ),
  );
}
