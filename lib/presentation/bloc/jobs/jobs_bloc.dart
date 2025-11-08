import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/core/network/api_client.dart';
import 'package:nas/data/models/job_model.dart';
import 'package:nas/presentation/bloc/jobs/jobs_event.dart';
import 'package:nas/presentation/bloc/jobs/jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final ApiClient _apiClient = ApiClient();

  JobsBloc() : super(JobsInitial()) {
    on<JobsFetchRequested>(_onFetchRequested);
    on<JobApplyRequested>(_onApplyRequested);
    on<JobCancelRequested>(_onCancelRequested);
  }
  Future<void> _onFetchRequested(
    JobsFetchRequested event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());
    try {
      final response = await _apiClient.get('/c/6f93-af9d-4728-ae7d');
      final jobs =
          (response.data as List)
              .map((item) => JobModel.fromJson(item))
              .where((job) => job.status == event.status) // filter by status
              .toList();

      emit(JobsLoaded(jobs));
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }

  Future<void> _onApplyRequested(
    JobApplyRequested event,
    Emitter<JobsState> emit,
  ) async {
    if (state is JobsLoaded) {
      final currentJobs = (state as JobsLoaded).jobs;

      // Mark job as pending for the current user
      final updatedJobs =
          currentJobs.map((job) {
            if (job.id == event.jobId) {
              job.isPending = true;
              job.appliedBy =
                  'currentUserId'; // replace with actual logged-in user ID
            }
            return job;
          }).toList();
      _onFetchRequested(const JobsFetchRequested(status: 'new'), emit);

      emit(JobsLoaded(updatedJobs));

      emit(const JobActionSuccess('تم التقديم على الوظيفة بنجاح'));
    }
  }

  Future<void> _onCancelRequested(
    JobCancelRequested event,
    Emitter<JobsState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      emit(const JobActionSuccess('تم إلغاء الطلب بنجاح'));

      // Refresh jobs list
      add(const JobsFetchRequested());
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }
}
