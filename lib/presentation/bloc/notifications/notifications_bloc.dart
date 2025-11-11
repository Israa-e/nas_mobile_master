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
      // Default local notifications (guaranteed to show at least one)
      final List<NotificationItem> notifications = [
        NotificationItem(
          title: 'تنبيه جديد',
          expiryDate:
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          type: 'تعليم كمقروء',
          detail: 'مرحباً بك في تطبيق NAS! هذا إشعار ترحيبي.',
          hasBlueHighlight: true,
        ),
      ];

      // Try to fetch additional notifications from API and append them
      try {
        final response = await _apiClient.get('/comments?_limit=5');
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          notifications.addAll(
            data.map((item) {
              final isRead = (item['id'] ?? 0) % 3 == 0;
              return NotificationItem(
                title: _getRandomNotificationType(item['id'] ?? 0),
                expiryDate: '${15 + ((item['id'] ?? 0) % 15)}/11/2025',
                type: isRead ? 'قراءة' : 'تعليم كمقروء',
                detail: item['body']?.toString() ?? 'تفاصيل الإشعار',
                hasBlueHighlight: !isRead,
              );
            }).toList(),
          );
        }
      } catch (e) {
        // Non-fatal: keep default notifications
        print('Warning: Could not fetch additional notifications: $e');
      }

      final unreadCount = notifications.where((n) => n.hasBlueHighlight).length;

      emit(
        NotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e, st) {
      print('Error loading notifications: $e\n$st');
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
