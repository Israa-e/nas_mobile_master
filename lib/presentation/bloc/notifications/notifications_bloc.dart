import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/core/network/api_client.dart';
import 'package:nas/data/models/notification_item.dart';
import 'package:nas/presentation/bloc/notifications/notifications_event.dart';
import 'package:nas/presentation/bloc/notifications/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final ApiClient _apiClient = ApiClient();

  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationsFetchRequested>(_onFetchRequested);
    on<NotificationMarkAsRead>(_onMarkAsRead);
    on<NotificationMarkAllAsRead>(_onMarkAllAsRead);
    on<NotificationDelete>(_onDelete);
  }

  Future<void> _onFetchRequested(
    NotificationsFetchRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    try {
      // Using JSONPlaceholder as dummy API
      final response = await _apiClient.get('/comments?_limit=15');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final notifications =
            data.map((item) {
              final isRead =
                  item['id'] % 3 == 0; // Simulate some read notifications
              return NotificationItem(
                title: _getRandomNotificationType(item['id']),
                expiryDate: '${15 + (item['id'] % 15)}/3/2025',
                type: isRead ? 'قراءة' : 'تعليم كمقروء',
                detail: item['body'],
                hasBlueHighlight: !isRead,
              );
            }).toList();

        final unreadCount =
            notifications.where((n) => n.hasBlueHighlight).length;

        emit(
          NotificationsLoaded(
            notifications: notifications,
            unreadCount: unreadCount,
          ),
        );
      } else {
        emit(const NotificationsError('فشل في تحميل الإشعارات'));
      }
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  String _getRandomNotificationType(int id) {
    final types = [
      'الإلغاء بعد الموافقة',
      'تم قبول طلبك',
      'تحديث على الطلب',
      'رسالة جديدة',
      'تنبيه مهم',
    ];
    return types[id % types.length];
  }

  Future<void> _onMarkAsRead(
    NotificationMarkAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedNotifications =
          currentState.notifications.map((notification) {
            if (notification.title ==
                currentState.notifications[event.notificationId].title) {
              return NotificationItem(
                title: notification.title,
                expiryDate: notification.expiryDate,
                type: 'قراءة',
                detail: notification.detail,
                hasBlueHighlight: false,
              );
            }
            return notification;
          }).toList();

      final unreadCount =
          updatedNotifications.where((n) => n.hasBlueHighlight).length;

      emit(
        NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ),
      );

      emit(const NotificationActionSuccess('تم تعليم الإشعار كمقروء'));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onMarkAllAsRead(
    NotificationMarkAllAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedNotifications =
          currentState.notifications.map((notification) {
            return NotificationItem(
              title: notification.title,
              expiryDate: notification.expiryDate,
              type: 'قراءة',
              detail: notification.detail,
              hasBlueHighlight: false,
            );
          }).toList();

      emit(
        NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: 0,
        ),
      );

      emit(const NotificationActionSuccess('تم تعليم جميع الإشعارات كمقروءة'));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onDelete(
    NotificationDelete event,
    Emitter<NotificationsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedNotifications = List<NotificationItem>.from(
        currentState.notifications,
      )..removeAt(event.notificationId);

      final unreadCount =
          updatedNotifications.where((n) => n.hasBlueHighlight).length;

      emit(
        NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ),
      );

      emit(const NotificationActionSuccess('تم حذف الإشعار'));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
