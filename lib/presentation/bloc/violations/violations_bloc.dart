import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _onFetchRequested(
    ViolationsFetchRequested event,
    Emitter<ViolationsState> emit,
  ) async {
    emit(ViolationsLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(ViolationsLoaded(List.from(_violations)));
  }

  Violation _generateRandomViolation(DateTime cancelDate) {
    final types = [
      'الإلغاء بعد الموافقة',
      'التأخر عن الموعد',
      'عدم الالتزام بالمعايير',
      'عدم إرسال المستندات',
    ];
    final reasons = [
      'تم إلغاء الوظيفة بعد الموافقة، تأكد من المواعيد القادمة.',
      'تأخر الموظف عن الحضور.',
      'عدم الالتزام بمعايير الشركة.',
      'لم يتم إرسال المستندات المطلوبة.',
    ];

    final id = cancelDate.millisecondsSinceEpoch;
    final expiryDate = cancelDate.add(const Duration(days: 15));
    return Violation(
      type: types[id % types.length],
      reason: reasons[id % reasons.length],
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
        final violation = _generateRandomViolation(state.cancelDate);
        add(ViolationAppealGenerated(violation));
      }
    });
  }
}
