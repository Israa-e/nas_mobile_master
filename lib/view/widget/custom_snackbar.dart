import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';

import '../../core/constant/url.dart';

void customSnackbar({
  String title = 'تم حفظ العملية',
  String message = 'تم حفظ التغييرات على المعلومات بنجاح',
  Duration duration = const Duration(seconds: 3),
  Color color = AppTheme.green,
  String icon = "check_circle",
}) {
  // Create a controller for the progress animation
  final progressController = ValueNotifier<double>(0.0);

  // Start the progress animation when the snackbar appears
  Future.delayed(Duration.zero, () {
    const animationDuration = Duration(milliseconds: 300);

    // Animate from 0 to 1 over animation duration
    Future.delayed(animationDuration, () {
      progressController.value = 1.0;
    });

    // Auto-close the snackbar after the specified duration
    Future.delayed(duration, () {
      Get.closeCurrentSnackbar();
      progressController.dispose();
    });
  });
  Get.snackbar(
    '', // Empty because we're using custom title text
    '', // Empty because we're using custom message text
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.all(16),
    padding: EdgeInsets.zero, // Remove default padding
    borderRadius: 0, // Remove default border radius
    boxShadows: [], // Remove default shadows
    snackPosition: SnackPosition.TOP,
    duration: duration,
    snackStyle: SnackStyle.FLOATING,

    // Remove the icon parameter so we can customize the layout
    titleText: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppTheme.primaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 30,
              offset: Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x23000000),
              blurRadius: 24,
              offset: Offset(0, 16),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 13,
                bottom: 6,
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  // Success check icon on the right side for RTL layout
                  // Text content aligned to the right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          message,
                          style: TextStyle(
                            color: AppTheme.primaryColor.withOpacity(0.6),
                            fontSize: 13,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset(
                    "${AppUrl.rootIcons}/$icon.svg",
                    height: 22,
                    width: 22,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: // Animated progress indicator
                  ValueListenableBuilder<double>(
                valueListenable: progressController,
                builder: (context, value, _) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1, end: 0),
                    duration: duration, // ← Sync with snackbar duration
                    builder: (context, animatedValue, _) {
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: LinearProgressIndicator(
                          value: animatedValue,
                          borderRadius: BorderRadius.circular(12),
                          backgroundColor: AppTheme.white,
                          color: color,
                          minHeight: 6,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    // Set messageText to empty SizedBox since we're handling both title and message in the titleText
    messageText: const SizedBox(),
  );
}

void showSuccessSnackbar({
  String title = 'تم حفظ العملية',
  String message = 'تم حفظ التغييرات على المعلومات بنجاح',
}) {
  customSnackbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    color: AppTheme.green,
    icon: "check_circle",
  );
}

void showInfoSnackbar({
  String title = 'خطوة مفقودة',
  String message = "يوجد حقل لم يتم تعبئته بشكل صحيح",
}) {
  customSnackbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    color: AppTheme.yeallow,
    icon: 'Info',
  );
}

void showErrorSnackbar({
  String title = 'حدث خطأ ما',
  String message = 'يوجد خطأ ما في العملية يرجى المحاولة مجدداً',
}) {
  customSnackbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    color: AppTheme.red,
    icon: "cancel",
  );
}
