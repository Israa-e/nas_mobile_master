import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/presentation/bloc/violations/violations_bloc.dart';
import 'package:nas/presentation/bloc/violations/violations_event.dart';
import 'package:nas/presentation/bloc/violations/violations_state.dart';
import 'package:nas/presentation/view/widget/build_header.dart';
import 'package:nas/presentation/view/widget/build_job_card.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

class ViolationsScreen extends StatefulWidget {
  const ViolationsScreen({super.key});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ViolationsBloc>().add(ViolationsFetchRequested());
  }

  void _showReasonDialog(String reason) {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  reason,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.026),
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
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
            buildHeader(image: "violations", text: "المخالفات"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ViolationsBloc>().add(
                    ViolationsFetchRequested(),
                  );
                },
                child: BlocConsumer<ViolationsBloc, ViolationsState>(
                  listener: (context, state) {
                    if (state is ViolationActionSuccess) {
                      showSuccessSnackbar(message: state.message);
                    } else if (state is ViolationsError) {
                      showErrorSnackbar(message: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is ViolationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ViolationsLoaded) {
                      if (state.violations.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا توجد مخالفات',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.violations.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final violation = state.violations[index];
                          return buildJobCard(
                            isViolation: true,
                            index: index,
                            violation: violation,
                            expiryDate: violation.expiryDate,
                            type: violation.type,
                            onTap: () => _showReasonDialog(violation.reason),
                            controller: null,
                            color: AppTheme.red,
                            text: "السبب",
                          );
                        },
                      );
                    } else if (state is ViolationsError) {
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
                                context.read<ViolationsBloc>().add(
                                  ViolationsFetchRequested(),
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
