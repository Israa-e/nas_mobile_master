import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nas/core/constant/theme.dart';

class FCMApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Singleton pattern to ensure only one instance
  static final FCMApi _instance = FCMApi._internal();
  factory FCMApi() => _instance;
  FCMApi._internal();

  /// Initialize Firebase Cloud Messaging and local notifications
  Future<void> initNotification() async {
    // Request notification permissions
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set up notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
    );

    // Create the Android notification channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Set up local notifications
    const InitializationSettings initSettings = InitializationSettings(
      // Use mipmap/ic_launcher instead of ic_launcher_foreground
      // android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    // Initialize local notifications
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = Uri.splitQueryString(response.payload!);
          _handleNotificationNavigation(data);
        }
      },
    );

    // Get FCM token for device registration
    final token = await firebaseMessaging.getToken();
    log("FCM Token: $token");

    // Handle notifications when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);
    });

    // Handle notifications when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("App opened from notification: ${message.notification?.title}");
      if (message.data.isNotEmpty) {
        _handleNotificationNavigation(message.data);
      }
    });

    /// Display a test notification locally without FCM message

    // Handle notifications when app was terminated
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      log(
        "App opened from terminated state: ${initialMessage.notification?.title}",
      );
      if (initialMessage.data.isNotEmpty) {
        _handleNotificationNavigation(initialMessage.data);
      }
    }
  }

  void showTestLocalNotification({
    required String title,
    required String body,
    Map<String, String>? data,
  }) {
    final payload = Uri(queryParameters: data ?? {}).query;

    flutterLocalNotificationsPlugin.show(
      title.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          // icon: '@mipmap/ic_launcher',
          color: AppTheme.primaryColor,
          // largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Display a local notification when a message is received
  void showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null) {
      final payload = Uri(queryParameters: message.data).query;

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            // icon:  '@mipmap/ic_launcher', // Ensure this icon exists in your project
            color: AppTheme.primaryColor, // Set your brand color here
            // largeIcon: const DrawableResourceAndroidBitmap(
            //   '@mipmap/ic_launcher',
            // ), // Optional large icon
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    }
  }

  /// Handle navigation based on notification data
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    log("Handling notification payload: $data");

    // Example navigation logic
    final String? screenName = data['screen'];
    final String? itemId = data['item_id'];

    if (screenName != null) {
      // Implement your navigation logic here
      // Example:
      // switch (screenName) {
      //   case 'product_details':
      //     if (itemId != null) {
      //       Get.to(() => ProductDetailsScreen(productId: itemId));
      //     }
      //     break;
      //   case 'order_status':
      //     Get.to(() => OrderStatusScreen());
      //     break;
      //   default:
      //     Get.to(() => NotificationsScreen());
      // }
    }
  }

  /// Subscribe to a topic for push notifications
  Future<void> subscribeToTopic(String topic) async {
    await firebaseMessaging.subscribeToTopic(topic);
    log('Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await firebaseMessaging.unsubscribeFromTopic(topic);
    log('Unsubscribed from topic: $topic');
  }
}
