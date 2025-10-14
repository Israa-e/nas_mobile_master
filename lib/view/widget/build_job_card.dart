import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/data/model/job_request.dart';

Widget buildJobCard({
  required int index,
  JobRequest? job,
  violation,
  type,
  expiryDate,
  controller,
  bool? isViolation,
  color,
  widget,
  onTap,
  text,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: Get.height * 0.02), // Responsive margin

    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Get.height * 0.015,
            ), // Responsive border radius
            border: Border.all(
              color: AppTheme.primaryColor,
              width: Get.width * 0.006,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: Get.height * 0.015, // Responsive blur radius
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Get.height * 0.015),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        isViolation == true ? type : job!.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Get.height * 0.01), // Responsive spacing
                      isViolation == true
                          ? Text(
                            'تنتهي في $expiryDate',

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                            textDirection: TextDirection.rtl,
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                job!.date,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(
                                width: Get.width * 0.12,
                              ), // Responsive spacing
                              Text(
                                job.timeRange,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        widget ??
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Get.height * 0.015,
              ), // Responsive border radius

              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.03,
                  ), // Responsive margin
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                        Get.height * 0.015,
                      ), // Responsive radius
                    ),
                    border: Border(
                      left: BorderSide(
                        color: color ?? AppTheme.blue,
                        width: Get.width * 0.01, // Responsive border width
                      ),
                      right: BorderSide(
                        color: color ?? AppTheme.blue,
                        width: Get.width * 0.01, // Responsive border width
                      ),
                      bottom: BorderSide(
                        color: color ?? AppTheme.blue,
                        width: Get.width * 0.01, // Responsive border width
                      ),
                      // No top border is specified
                    ),
                  ),
                  child: Text(
                    text ?? "تقدم الآن",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
      ],
    ),
  );
}
