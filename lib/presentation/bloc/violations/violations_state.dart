import 'package:equatable/equatable.dart';
import 'package:nas/data/models/violation.dart';

abstract class ViolationsState extends Equatable {
  const ViolationsState();
  @override
  List<Object?> get props => [];
}

class ViolationsInitial extends ViolationsState {}

class ViolationsLoading extends ViolationsState {}

class ViolationsLoaded extends ViolationsState {
  final List<Violation> violations;
  const ViolationsLoaded(this.violations);

  @override
  List<Object?> get props => [violations];
}

class ViolationsError extends ViolationsState {
  final String message;
  const ViolationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ViolationActionSuccess extends ViolationsState {
  final String message;
  const ViolationActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
