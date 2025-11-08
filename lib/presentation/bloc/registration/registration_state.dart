import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {
  final int currentPage;
  final Map<int, Map<String, dynamic>> pagesData; // store each page data

  const RegistrationInitial({this.currentPage = 0, this.pagesData = const {}});

  RegistrationInitial copyWith({
    int? currentPage,
    Map<int, Map<String, dynamic>>? pagesData,
  }) {
    return RegistrationInitial(
      currentPage: currentPage ?? this.currentPage,
      pagesData: pagesData ?? this.pagesData,
    );
  }

  @override
  List<Object?> get props => [currentPage, pagesData];
}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String message;
  const RegistrationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RegistrationError extends RegistrationState {
  final String message;
  const RegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}
