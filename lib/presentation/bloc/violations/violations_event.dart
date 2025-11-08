import 'package:equatable/equatable.dart';
import 'package:nas/data/models/violation.dart';

abstract class ViolationsEvent extends Equatable {
  const ViolationsEvent();
  @override
  List<Object?> get props => [];
}

class ViolationsFetchRequested extends ViolationsEvent {}

class ViolationAppealGenerated extends ViolationsEvent {
  final Violation violation;
  const ViolationAppealGenerated(this.violation);

  @override
  List<Object?> get props => [violation];
}
