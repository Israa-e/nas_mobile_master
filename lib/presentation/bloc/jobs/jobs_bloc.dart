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
    try {
      final rawJobs = await _dbHelper.getAllJobs2(status: event.status);
      final jobs = rawJobs.map((json) => JobModel.fromJson(json)).toList();
      print('📋 Fetched ${jobs.length} jobs with status: ${event.status}');
      emit(JobsLoaded(jobs));
    } catch (e) {
      print('❌ Error fetching jobs: $e');
      emit(JobsError('خطأ في تحميل الوظائف: $e'));
    }
  }

  Future<void> _onJobApproveRequested(
    JobApproveRequested event,
    Emitter<JobsState> emit,
  ) async {
    print('✅ Starting approval process for job ${event.jobId}');

    try {
      // First, verify the job exists and is still pending
      final jobData = await _dbHelper.getJob(event.jobId);
      if (jobData == null) {
        print('❌ Job ${event.jobId} not found in database');
        emit(JobsError('الوظيفة غير موجودة'));
        return;
      }

      print(
        '📄 Current job status: ${jobData['status']}, isPending: ${jobData['isPending']}',
      );

      final currentUserId = await SharedPrefsHelper.getUserId();
      print('👤 Current user ID: $currentUserId');

      // Update job to approved
      final updateResult = await _dbHelper.updateJob(event.jobId, {
        'status': 'approved',
        'isPending': 0,
        'appliedBy': currentUserId,
      });

      print('✅ Database update result: $updateResult rows affected');

      // Verify the update
      final updatedJob = await _dbHelper.getJob(event.jobId);
      print(
        '📄 Updated job status: ${updatedJob?['status']}, isPending: ${updatedJob?['isPending']}',
      );

      // Cancel the timer for this job
      if (_pendingTimers.containsKey(event.jobId)) {
        _pendingTimers[event.jobId]?.cancel();
        _pendingTimers.remove(event.jobId);
        print('⏰ Timer cancelled for job ${event.jobId}');
      }

      // Emit success message
      emit(const JobActionSuccess('تمت الموافقة على الوظيفة تلقائيًا'));

      // Small delay to ensure state is emitted
      await Future.delayed(const Duration(milliseconds: 300));

      // Refresh both pending and approved lists
      print('🔄 Refreshing pending jobs list...');
      add(const JobsFetchRequested(status: 'pending'));

      await Future.delayed(const Duration(milliseconds: 100));

      print('🔄 Refreshing approved jobs list...');
      add(const JobsFetchRequested(status: 'approved'));
    } catch (e, stackTrace) {
      print('❌ Error in approval process: $e');
      print('Stack trace: $stackTrace');
      emit(JobsError('خطأ أثناء الموافقة على الوظيفة: $e'));
    }
  }

  Future<void> _onJobCancelRequested(
    JobCancelRequested event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());
    try {
      // Get current job status before cancelling
      final jobData = await _dbHelper.getJob(event.jobId);
      final wasApproved = jobData?['status'] == 'approved';

      // Update job status to 'new' (cancelled)
      await _dbHelper.updateJob(event.jobId, {
        'status': 'new',
        'isPending': 0,
        'appliedBy': null,
      });

      // Emit cancellation event with job status
      emit(JobCancelledEvent(event.jobId, DateTime.now()));

      // Show different message based on previous status
      final message =
          wasApproved
              ? 'تم إلغاء الطلب بنجاح. تم إضافة مخالفة بسبب الإلغاء بعد الموافقة.'
              : 'تم إلغاء الطلب بنجاح';

      emit(JobActionSuccess(message));
    } catch (e) {
      emit(JobsError('خطأ أثناء إلغاء الوظيفة: $e'));
    }
  }

  Future<void> _onJobAppliedRequested(
    JobAppliedRequested event,
    Emitter<JobsState> emit,
  ) async {
    print('📝 Applying for job ${event.jobId}');
    emit(JobsLoading());

    try {
      final currentUserId = await SharedPrefsHelper.getUserId();

      if (currentUserId == null) {
        print('❌ No user ID found');
        emit(const JobsError('يرجى تسجيل الدخول أولاً'));
        return;
      }

      print('👤 Applying with user ID: $currentUserId');

      await _dbHelper.updateJob(event.jobId, {
        'status': 'pending',
        'isPending': 1,
        'appliedBy': currentUserId,
      });

      // Verify the update
      final updatedJob = await _dbHelper.getJob(event.jobId);
      print(
        '📄 Job ${event.jobId} updated: status=${updatedJob?['status']}, isPending=${updatedJob?['isPending']}',
      );

      emit(const JobActionSuccess('تم التقديم على الوظيفة بنجاح'));

      print('⏰ Setting up auto-approval timer for job ${event.jobId}...');
      print(
        '⏰ Timer will fire at: ${DateTime.now().add(const Duration(seconds: 10))}',
      ); // Changed to 10 seconds for testing

      // Automatically approve after 10 seconds (for testing)
      if (_pendingTimers.containsKey(event.jobId)) {
        print('⚠️ Cancelling existing timer for job ${event.jobId}');
        _pendingTimers[event.jobId]?.cancel();
        _pendingTimers.remove(event.jobId);
      }

      final timer = Timer(const Duration(seconds: 10), () async {
        print('🔔 TIMER FIRED for job ${event.jobId}!');
        print('🔔 Time: ${DateTime.now()}');
        print('🔔 Bloc closed: $isClosed');

        if (!isClosed) {
          try {
            // Verify job is still pending before auto-approving
            final jobData = await _dbHelper.getJob(event.jobId);
            if (jobData != null && jobData['status'] == 'pending') {
              print('🔄 Auto-approving job ${event.jobId}...');
              add(JobApproveRequested(event.jobId));
            } else {
              print(
                '⚠️ Job ${event.jobId} is no longer pending, skipping auto-approve',
              );
            }
          } catch (e) {
            print('❌ Error in auto-approve timer: $e');
          } finally {
            _pendingTimers.remove(event.jobId);
          }
        } else {
          print('⚠️ Bloc is closed, cannot approve job');
          _pendingTimers.remove(event.jobId);
        }
      });

      // Store timer for this specific job
      _pendingTimers[event.jobId] = timer;
      print(
        '✅ Timer stored for job ${event.jobId}. Active timers: ${_pendingTimers.length}',
      );
    } catch (e, stackTrace) {
      print('❌ Error applying for job: $e');
      print('Stack trace: $stackTrace');
      emit(JobsError('خطأ أثناء التقديم على الوظيفة: $e'));
    }
  }

  @override
  Future<void> close() {
    print('🛑 Closing JobsBloc. Cancelling ${_pendingTimers.length} timers...');

    // Cancel all pending timers
    _approvalTimer?.cancel();
    for (var entry in _pendingTimers.entries) {
      print('⏰ Cancelling timer for job ${entry.key}');
      entry.value.cancel();
    }
    _pendingTimers.clear();

    print('✅ All timers cancelled');
    return super.close();
  }
}
