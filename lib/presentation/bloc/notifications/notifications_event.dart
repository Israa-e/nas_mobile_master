import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsFetchRequested extends NotificationsEvent {}

class NotificationMarkAsRead extends NotificationsEvent {
  final int notificationId;

  const NotificationMarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class NotificationMarkAllAsRead extends NotificationsEvent {}

class NotificationDelete extends NotificationsEvent {
  final int notificationId;

  const NotificationDelete(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
