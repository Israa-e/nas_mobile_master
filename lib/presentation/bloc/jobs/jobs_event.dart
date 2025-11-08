import 'package:equatable/equatable.dart';
import 'package:nas/data/models/job_model.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object?> get props => [];
}

class JobsFetchRequested extends JobsEvent {
  final String? status;
  const JobsFetchRequested({this.status});

  @override
  List<Object?> get props => [status];
}

class JobsFetchedFromDb extends JobsEvent {
  final List<JobModel> jobs;
  const JobsFetchedFromDb(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class JobCancelRequested extends JobsEvent {
  final int jobId;
  const JobCancelRequested(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class JobApproveRequested extends JobsEvent {
  final int jobId;

  const JobApproveRequested(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class JobAppliedRequested extends JobsEvent {
  final int jobId;
  const JobAppliedRequested(this.jobId);

  @override
  List<Object?> get props => [jobId];
}
