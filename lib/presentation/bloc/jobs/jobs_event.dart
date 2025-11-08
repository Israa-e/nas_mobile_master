import 'package:equatable/equatable.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object?> get props => [];
}

class JobsFetchRequested extends JobsEvent {
  final String? status; // 'new', 'pending', 'approved', 'rejected'

  const JobsFetchRequested({this.status});

  @override
  List<Object?> get props => [status];
}

class JobApplyRequested extends JobsEvent {
  final int jobId;

  const JobApplyRequested(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class JobCancelRequested extends JobsEvent {
  final int jobId;

  const JobCancelRequested(this.jobId);

  @override
  List<Object?> get props => [jobId];
}
