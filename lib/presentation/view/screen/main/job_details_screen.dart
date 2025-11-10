import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/data/models/job_model.dart';
import 'package:nas/presentation/view/widget/button_border.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';
import 'package:nas/presentation/view/widget/primary_button.dart';

class JobDetailsScreen extends StatefulWidget {
  final JobModel job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool isLoading = false;

  Future<void> _applyForJob(state) async {
    setState(() => isLoading = true);

    try {
      final currentUserId = await SharedPrefsHelper.getUserId();
      if (currentUserId == null) {
        showErrorSnackbar(message: 'يرجى تسجيل الدخول أولاً');
        setState(() => isLoading = false);
        return;
      }
      // Update job status in database
      await _dbHelper.updateJob(widget.job.id, {
        'status': 'pending',
        'isPending': 1,
        'appliedBy': currentUserId, // Use actual user ID
      });

      setState(() => isLoading = false);

      // Show success dialog
      _showSuccessDialog();
    } catch (e) {
      setState(() => isLoading = false);
      showErrorSnackbar(message: 'حدث خطأ أثناء التقديم');
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Dialog(
            shadowColor: AppTheme.backgroundTransparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "يمكنك متابعة الطلب من خلال زر الانتظار في أسفل الصفحة",
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
                      PrimaryButton(
                        onTap: () {
                          Get.back(); // Close dialog
                          Get.back(); // Go back to previous screen
                          showSuccessSnackbar(message: 'تم التقديم بنجاح');
                        },
                        text: 'تأكيد',
                        height: Get.height * 0.04,
                        borderRadius: 10,
                        textColor: AppTheme.white,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 30),
                      ButtonBorder(
                        height: Get.height * 0.04,
                        borderRadius: 10,
                        onTap: () => Get.back(),
                        text: "إلغاء",
                        color: AppTheme.red,
                      ),
                    ],
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

  @override
  Widget build(BuildContext context) {
    // Parse requirements if they exist
    List<String> requirements = [];
    if (widget.job.requirements != null) {
      requirements = widget.job.requirements!;
    }

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'تفاصيل الوظيفة',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.job.title,
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: AppTheme.white,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${widget.job.day} - ${widget.job.date}',
                                style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: AppTheme.white,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${widget.job.startTime} - ${widget.job.endTime}',
                                style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Description Section
                    if (widget.job.description != null) ...[
                      _buildSectionTitle('الوصف'),
                      _buildInfoCard(
                        icon: Icons.description,
                        content: widget.job.description!,
                      ),
                      const SizedBox(height: 15),
                    ],

                    // Location Section
                    if (widget.job.location != null) ...[
                      _buildSectionTitle('الموقع'),
                      _buildInfoCard(
                        icon: Icons.location_on,
                        content: widget.job.location!,
                      ),
                      const SizedBox(height: 15),
                    ],

                    // Salary Section
                    if (widget.job.salary != null) ...[
                      _buildSectionTitle('الراتب'),
                      _buildInfoCard(
                        icon: Icons.attach_money,
                        content: widget.job.salary!,
                      ),
                      const SizedBox(height: 15),
                    ],

                    // Requirements Section
                    if (requirements.isNotEmpty) ...[
                      _buildSectionTitle('المتطلبات'),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              requirements.map((req) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppTheme.green,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          req,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: MediaQuery.of(context).viewPadding.bottom + 20,
          top: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onTap: () async {
                  setState(() => isLoading = true);

                  try {
                    final currentUserId = await SharedPrefsHelper.getUserId();
                    if (currentUserId == null) {
                      showErrorSnackbar(message: 'يرجى تسجيل الدخول أولاً');
                      setState(() => isLoading = false);
                      return;
                    }
                    // Update job status in database
                    await _dbHelper.updateJob(widget.job.id, {
                      'status': 'pending',
                      'isPending': 1,
                      'appliedBy': currentUserId, // Use actual user ID
                    });

                    setState(() => isLoading = false);

                    // Show success dialog
                    _showSuccessDialog();
                  } catch (e) {
                    setState(() => isLoading = false);
                    showErrorSnackbar(message: 'حدث خطأ أثناء التقديم');
                  }
                },
                text: "تقدم الآن",
                height: 50,
                borderRadius: 15,
                color: AppTheme.primaryColor,
                textColor: AppTheme.white,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ButtonBorder(
                onTap: () => Get.back(),
                text: "رجوع",
                height: 50,
                color: AppTheme.red,
                borderRadius: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String content}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primaryColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.primaryColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
