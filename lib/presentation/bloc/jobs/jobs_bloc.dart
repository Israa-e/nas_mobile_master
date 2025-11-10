import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/data/models/job_model.dart';
import 'jobs_event.dart';
import 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Timer? _approvalTimer;
  final Map<int, Timer> _pendingTimers = {}; // Track timers per job

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

      // Update job to approved
      await _dbHelper.updateJob(event.jobId, {
        'status': 'approved',
        'isPending': 0,
        'appliedBy': currentUserId,
      });

      // Cancel the timer for this job
      _pendingTimers[event.jobId]?.cancel();
      _pendingTimers.remove(event.jobId);

      // Emit success message
      emit(const JobActionSuccess('تمت الموافقة على الوظيفة تلقائيًا'));

      // **KEY FIX**: Fetch BOTH pending and approved jobs to update both screens
      // This ensures WaitingScreen removes the job and ApprovalsScreen shows it
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Small delay for state update
      add(const JobsFetchRequested(status: 'pending')); // Update waiting screen
      add(
        const JobsFetchRequested(status: 'approved'),
      ); // Update approvals screen
    } catch (e) {
      emit(JobsError('خطأ أثناء الموافقة على الوظيفة: $e'));
    }
  }

  Future<void> _onJobCancelRequested(
    JobCancelRequested event,
    Emitter<JobsState> emit,
  ) async {
    try {
      // Cancel any pending timer for this job
      _pendingTimers[event.jobId]?.cancel();
      _pendingTimers.remove(event.jobId);

      await _dbHelper.updateJob(event.jobId, {
        'status': 'new',
        'isPending': 0,
        'appliedBy': null,
      });

      // Emit cancellation event with date
      emit(JobCancelledEvent(event.jobId, DateTime.now()));
      emit(const JobActionSuccess('تم إلغاء الطلب بنجاح'));

      // Refresh pending jobs list
      add(const JobsFetchRequested(status: 'pending'));
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

      // ⏰ Automatically approve after 1 minute
      final timer = Timer(const Duration(minutes: 1), () {
        if (!isClosed) {
          print('🔄 Auto-approving job ${event.jobId} after 1 minute');
          add(JobApproveRequested(event.jobId));
        }
      });

      // Store timer for this specific job
      _pendingTimers[event.jobId] = timer;
    } catch (e) {
      emit(JobsError('خطأ أثناء التقديم على الوظيفة: $e'));
    }
  }

  @override
  Future<void> close() {
    // Cancel all pending timers
    _approvalTimer?.cancel();
    for (var timer in _pendingTimers.values) {
      timer.cancel();
    }
    _pendingTimers.clear();
    return super.close();
  }
}
