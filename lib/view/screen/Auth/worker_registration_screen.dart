import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nas/controller/worker_registration_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/primary_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WorkerRegistrationScreen extends StatelessWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkerRegistrationController controller =
        Get.find<WorkerRegistrationController>();

    return WillPopScope(
      onWillPop: () => controller.handleSwipeBack().then((_) => false),

      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            double velocity = details.primaryVelocity ?? 0;

            if (velocity.abs() < 200) return; // تجاهل السحب الخفيف
            if (velocity < 0) {
              // السحب من اليمين إلى اليسار
              controller.handleSwipeBack();
            } else {
              controller.nextPage();
            }
          },
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5.h),

                  Image.asset(
                    AppUrl.logo,
                    height: Get.height * 0.1, // 10% من ارتفاع الشاشة
                    width: Get.width * 0.2,
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged:
                          (index) => controller.currentPage.value = index,
                      children: controller.pages, // Dynamically load pages
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 33.0, right: 33, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: SmoothPageIndicator(
                  controller: controller.pageController,
                  count: controller.totalPages,

                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    dotColor: Colors.white,
                    activeDotColor: Colors.white,
                    paintStyle: PaintingStyle.stroke,
                    strokeWidth: 1,
                    type: WormType.thinUnderground,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Padding(
                padding: EdgeInsets.only(bottom: Get.height / 20, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => PrimaryButton(
                          onTap: controller.submitSurvey,
                          text:
                              controller.currentPage.value ==
                                      controller.totalPages - 1
                                  ? "إرسال"
                                  : "التالي",
                        ),
                      ),
                    ),

                    SizedBox(width: 40),

                    Expanded(
                      child: Obx(
                        () => ButtonBorder(
                          onTap:
                              controller.currentPage.value == 0
                                  ? () {
                                    bool hasData = controller
                                        .validateCurrentPage(
                                          showSnackbar: false,
                                        );
                                    if (hasData) {
                                      controller.showBackDialog();
                                    } else {
                                      Get.back();
                                    }
                                  }
                                  : controller.previousPage,
                          text: "عودة",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
