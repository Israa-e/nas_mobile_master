import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/presentation/bloc/jobs/jobs_bloc.dart';
import 'package:nas/presentation/bloc/jobs/jobs_event.dart';
import 'package:nas/presentation/bloc/jobs/jobs_state.dart';
import 'package:nas/presentation/view/widget/build_header.dart';
import 'package:nas/presentation/view/widget/build_job_card.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final String currentUserId =
      'currentUserId'; // replace with actual logged-in user ID

  @override
  void initState() {
    super.initState();
    context.read<JobsBloc>().add(const JobsFetchRequested(status: 'pending'));
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "تم إرسال طلبك للعميل\nيمكن أن تؤدي عملية الإلغاء إلى خفض درجاتك أو حظرك عن العمل",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
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
            buildHeader(image: "wait", text: "طلبات قيد الإنتظار"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<JobsBloc>().add(
                    const JobsFetchRequested(status: 'pending'),
                  );
                },
                child: BlocConsumer<JobsBloc, JobsState>(
                  listener: (context, state) {
                    if (state is JobActionSuccess) {
                      showSuccessSnackbar(message: state.message);
                      context.read<JobsBloc>().add(
                        const JobsFetchRequested(status: 'pending'),
                      );
                    } else if (state is JobsError) {
                      showErrorSnackbar(message: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is JobsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JobsLoaded) {
                      final pendingJobs =
                          state.jobs
                              .where(
                                (job) =>
                                    job.isPending &&
                                    job.appliedBy == currentUserId,
                              )
                              .toList();

                      if (pendingJobs.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا توجد طلبات في الانتظار',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: pendingJobs.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final job = pendingJobs[index];
                          return buildJobCard(
                            index: index,
                            onTap: () => _showCancelDialog(job.id),
                            color: AppTheme.red,
                            job: job,
                            type: job.title,
                            controller: null,
                            text: "إلغاء",
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
                                  const JobsFetchRequested(status: 'pending'),
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
