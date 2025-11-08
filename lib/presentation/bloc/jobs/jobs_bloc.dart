import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/data/models/job_model.dart';
import 'jobs_event.dart';
import 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  JobsBloc() : super(JobsInitial()) {
    on<JobsFetchRequested>(_onJobsFetchRequested);
    on<JobCancelRequested>(_onJobCancelRequested);
    on<JobAppliedRequested>(_onJobAppliedRequested);
    on<JobApproveRequested>(_onJobApproveRequested);
  }

  Future<void> _onJobsFetchRequested(
    JobsFetchRequested event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());
    final rawJobs = await _dbHelper.getAllJobs2(status: event.status);
    final jobs = rawJobs.map((json) => JobModel.fromJson(json)).toList();
    emit(JobsLoaded(jobs));
  }

  Future<void> _onJobApproveRequested(
    JobApproveRequested event,
    Emitter<JobsState> emit,
  ) async {
    try {
      final currentUserId = await SharedPrefsHelper.getUserId();
      await _dbHelper.updateJob(event.jobId, {
        'status': 'approved',
        'isPending': 0,
        'appliedBy': currentUserId,
      });
      emit(const JobActionSuccess('تمت الموافقة على الوظيفة تلقائيًا'));
      add(JobsFetchRequested(status: 'approved'));
    } catch (e) {
      emit(JobsError('خطأ أثناء الموافقة على الوظيفة: $e'));
    }
  }

  Future<void> _onJobCancelRequested(
    JobCancelRequested event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());
    try {
      await _dbHelper.updateJob(event.jobId, {
        'status': 'new',
        'isPending': 0,
        'appliedBy': null,
      });

      // Emit cancellation event with date
      emit(JobCancelledEvent(event.jobId, DateTime.now()));

      emit(const JobActionSuccess('تم إلغاء الطلب بنجاح'));
    } catch (e) {
      emit(JobsError('خطأ أثناء إلغاء الوظيفة: $e'));
    }
  }

  Future<void> _onJobAppliedRequested(
    JobAppliedRequested event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());
    try {
      final currentUserId = await SharedPrefsHelper.getUserId();
      await _dbHelper.updateJob(event.jobId, {
        'status': 'pending',
        'isPending': 1,
        'appliedBy': currentUserId,
      });
      emit(const JobActionSuccess('تم التقديم على الوظيفة بنجاح'));
    } catch (e) {
      emit(JobsError('خطأ أثناء التقديم على الوظيفة: $e'));
    }
  }
}
