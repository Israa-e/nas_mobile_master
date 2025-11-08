import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/data/models/job_model.dart';
import 'package:nas/presentation/bloc/jobs/jobs_bloc.dart';
import 'package:nas/presentation/bloc/jobs/jobs_event.dart';
import 'package:nas/presentation/bloc/jobs/jobs_state.dart';
import 'package:nas/presentation/view/widget/build_header.dart';
import 'package:nas/presentation/view/widget/build_job_card.dart';
import 'package:nas/presentation/view/widget/button_border.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';
import 'package:nas/presentation/view/widget/primary_button.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch new jobs when screen loads
    context.read<JobsBloc>().add(const JobsFetchRequested(status: 'new'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            buildHeader(image: 'new', text: "طلبات جديدة"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {},
                child: BlocConsumer<JobsBloc, JobsState>(
                  listener: (context, state) {
                    if (state is JobActionSuccess) {
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
                            'لا توجد وظائف متاحة',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.jobs.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final job = state.jobs[index];
                          return buildJobCard(
                            index: index,
                            onTap: () {
                              showSuccessDialog(job: job);
                            },
                            job: job,
                            type: job.title,
                            controller: null,
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
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog({required JobModel job}) {
    Get.dialog(
      Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.5), // لون داكن شفاف
            ),
          ),
          Dialog(
            shadowColor: AppTheme.backgroundTransparent,
            // Add margin to the entire Dialog
            insetPadding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
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
                          Get.back();
                          context.read<JobsBloc>().add(
                            JobApplyRequested(job.id),
                          );
                        },
                        text: 'تأكيد',
                        height: Get.height * 0.04,
                        borderRadius: 10,

                        textColor: AppTheme.white,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 30),
                      ButtonBorder(
                        height: Get.height * 0.04,
                        borderRadius: 10,
                        onTap: () => Get.back(),
                        text: "إالغاء",

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
}
