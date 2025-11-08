import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/presentation/bloc/jobs/jobs_bloc.dart';
import 'package:nas/presentation/bloc/jobs/jobs_event.dart';
import 'package:nas/presentation/bloc/jobs/jobs_state.dart';
import 'package:nas/presentation/view/screen/main/location.dart';
import 'package:nas/presentation/view/widget/build_header.dart';
import 'package:nas/presentation/view/widget/build_job_card.dart';
import 'package:nas/presentation/view/widget/button_border.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<JobsBloc>().add(const JobsFetchRequested(status: 'approved'));
  }

  void showDeleteDialog(int jobId) {
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
                  const Text(
                    "يمكن أن تؤدي عملية الإلغاء إلى خفض درجاتك أو حظرك عن العمل",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: Get.height * 0.026),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonBorder(
                        height: Get.height * 0.04,
                        borderRadius: 10,
                        onTap: () {
                          // Close dialog first
                          Get.back();

                          // Add cancellation event
                          context.read<JobsBloc>().add(
                            JobCancelRequested(jobId),
                          );
                        },
                        text: 'تأكيد',
                        color: AppTheme.red,
                      ),
                      const SizedBox(width: 30),
                      ButtonBorder(
                        height: Get.height * 0.04,
                        borderRadius: 10,
                        onTap: () => Get.back(),
                        text: "إغلاق",
                        color: AppTheme.primaryColor,
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
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            buildHeader(image: "accept", text: "طلبات موافق عليها"),
            Expanded(
              child: BlocConsumer<JobsBloc, JobsState>(
                listener: (context, state) {
                  if (state is JobActionSuccess) {
                    // Refresh approved jobs when a job is approved
                    context.read<JobsBloc>().add(
                      const JobsFetchRequested(status: 'approved'),
                    );
                    showSuccessSnackbar(message: state.message);
                  } else if (state is JobsError) {
                    showErrorSnackbar(message: state.message);
                  }
                },
                builder: (context, state) {
                  if (state is JobsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is JobsLoaded) {
                    if (state.jobs.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد طلبات موافق عليها',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.jobs.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final job = state.jobs[index];
                        return buildJobCard(
                          index: index,
                          job: job,
                          type: job.title,
                          controller: null,
                          widget: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),

                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Get.to(() => const Location()),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        'الموقع',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => showDeleteDialog(job.id),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        'إلغاء',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is JobsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
