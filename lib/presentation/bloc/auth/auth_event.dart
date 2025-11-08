import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String phone;
  final String password;

  const AuthLoginRequested({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final String phone;
  final String password;
  final String name;

  const AuthRegisterRequested({
    required this.phone,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [phone, password, name];
}
