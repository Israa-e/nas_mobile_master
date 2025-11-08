import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

// Page navigation
class RegistrationNextPage extends RegistrationEvent {}

class RegistrationPreviousPage extends RegistrationEvent {}

class RegistrationJumpToPage extends RegistrationEvent {
  final int page;
  const RegistrationJumpToPage(this.page);
}

// Page data updates
class RegistrationPageDataUpdated extends RegistrationEvent {
  final int page;
  final Map<String, dynamic> data;
  const RegistrationPageDataUpdated({required this.page, required this.data});
}

// Submit registration
class RegistrationSubmitted extends RegistrationEvent {
  final Map<String, dynamic> allData;
  const RegistrationSubmitted(this.allData);
}

// Reset registration
class RegistrationReset extends RegistrationEvent {}
