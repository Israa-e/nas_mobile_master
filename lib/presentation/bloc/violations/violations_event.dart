import 'package:equatable/equatable.dart';

abstract class ViolationsEvent extends Equatable {
  const ViolationsEvent();

  @override
  List<Object?> get props => [];
}

class ViolationsFetchRequested extends ViolationsEvent {}

class ViolationAppeal extends ViolationsEvent {
  final int violationId;
  final String reason;

  const ViolationAppeal({required this.violationId, required this.reason});

  @override
  List<Object?> get props => [violationId, reason];
}
