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
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JobsBloc>().add(const JobsFetchRequested(status: 'approved'));
  }

  void _showCancelDialog(int jobId) {
    Get.dialog(
      Dialog(
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
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      context.read<JobsBloc>().add(JobCancelRequested(jobId));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'تأكيد',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 30),
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<JobsBloc>().add(
                    const JobsFetchRequested(status: 'approved'),
                  );
                },
                child: BlocConsumer<JobsBloc, JobsState>(
                  listener: (context, state) {
                    if (state is JobActionSuccess) {
                      showSuccessSnackbar(message: state.message);
                      context.read<JobsBloc>().add(
                        const JobsFetchRequested(status: 'approved'),
                      );
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
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => const Location());
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: const Text(
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
                                      onTap: () => _showCancelDialog(job.id),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(16),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: const Text(
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
                      );
                    } else if (state is JobsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<JobsBloc>().add(
                                  const JobsFetchRequested(status: 'approved'),
                                );
                              },
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
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
}
