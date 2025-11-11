import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/core/database/database_helper.dart';
import 'violations_event.dart';
import 'violations_state.dart';
import 'package:nas/data/models/violation.dart';
import '../jobs/jobs_state.dart';

class ViolationsBloc extends Bloc<ViolationsEvent, ViolationsState> {
  ViolationsBloc() : super(ViolationsInitial()) {
    on<ViolationsFetchRequested>(_onFetchRequested);
    on<ViolationAppealGenerated>(_onViolationGenerated);
  }

  final List<Violation> _violations = [];
  final Random _random = Random();

  Future<void> _onFetchRequested(
    ViolationsFetchRequested event,
    Emitter<ViolationsState> emit,
  ) async {
    emit(ViolationsLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(ViolationsLoaded(List.from(_violations)));
  }

  Violation _generateRandomViolation(DateTime cancelDate, bool wasApproved) {
    // More serious violations for post-approval cancellations
    final types =
        wasApproved
            ? [
              'الإلغاء بعد الموافقة',
              'عدم الالتزام بالتعهد',
              'مخالفة شروط العمل',
              'إلغاء متكرر بعد الموافقة',
            ]
            : [
              'الإلغاء قبل الموافقة',
              'التأخر عن الموعد',
              'عدم الالتزام بالمعايير',
              'عدم إرسال المستندات',
            ];

    final reasons =
        wasApproved
            ? [
              'تم إلغاء الوظيفة بعد الموافقة عليها مما يؤثر على سمعة العامل ويسبب خسائر للعميل.',
              'عدم الالتزام بالتعهد بعد الموافقة على العمل يعتبر مخالفة جسيمة.',
              'مخالفة شروط وأحكام العمل المتفق عليها بعد تأكيد الموافقة.',
              'تكرار إلغاء الطلبات بعد الموافقة عليها قد يؤدي إلى حظر الحساب.',
            ]
            : [
              'تم إلغاء الطلب قبل الموافقة عليه.',
              'تأخر العامل عن الحضور في الموعد المحدد.',
              'عدم الالتزام بمعايير الشركة المطلوبة.',
              'لم يتم إرسال المستندات المطلوبة في الوقت المحدد.',
            ];

    // Select random violation
    final randomIndex = _random.nextInt(types.length);

    // Calculate expiry date (more days for serious violations)
    final daysToAdd =
        wasApproved
            ? 30 + _random.nextInt(31)
            : 15 + _random.nextInt(16); // 30-60 days or 15-30 days
    final expiryDate = cancelDate.add(Duration(days: daysToAdd));

    return Violation(
      type: types[randomIndex],
      reason: reasons[randomIndex],
      expiryDate: '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}',
    );
  }

  Future<void> _onViolationGenerated(
    ViolationAppealGenerated event,
    Emitter<ViolationsState> emit,
  ) async {
    _violations.add(event.violation);
    emit(ViolationsLoaded(List.from(_violations)));
  }

  void attachJobCancellationListener(Bloc<dynamic, dynamic> jobsBloc) {
    jobsBloc.stream.listen((state) {
      if (state is JobCancelledEvent) {
        _checkAndGenerateViolation(state.jobId, state.cancelDate);
      }
    });
  }

  Future<void> _checkAndGenerateViolation(
    int jobId,
    DateTime cancelDate,
  ) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final jobData = await dbHelper.getJob(jobId);

      if (jobData != null) {
        // Check current status and previous status
        final currentStatus = jobData['status'];

        // Consider it was approved if currently approved OR if it was approved before
        final wasApproved = currentStatus == 'approved';

        // Generate random violation based on approval status
        final violation = _generateRandomViolation(cancelDate, wasApproved);
        add(ViolationAppealGenerated(violation));

        print(
          '✅ Generated ${wasApproved ? "serious" : "standard"} violation for job #$jobId: ${violation.type}',
        );
      }
    } catch (e) {
      print('❌ Error generating violation: $e');
    }
  }
}
