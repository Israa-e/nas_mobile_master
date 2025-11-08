import 'package:equatable/equatable.dart';
import 'package:nas/data/models/job_model.dart';

abstract class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object?> get props => [];
}

class JobsInitial extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final List<JobModel> jobs;
  const JobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class JobCancelledEvent extends JobsState {
  final int jobId;
  final DateTime cancelDate;
  const JobCancelledEvent(this.jobId, this.cancelDate);

  @override
  List<Object?> get props => [jobId, cancelDate];
}

class JobActionSuccess extends JobsState {
  final String message;
  const JobActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class JobsError extends JobsState {
  final String message;
  const JobsError(this.message);

  @override
  List<Object?> get props => [message];
}
