import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:nas/presentation/bloc/notifications/notifications_event.dart';
import 'package:nas/presentation/bloc/notifications/notifications_state.dart';
import 'package:nas/presentation/view/widget/build_header.dart';
import 'package:nas/presentation/view/widget/build_job_card.dart';
import 'package:nas/presentation/view/widget/button_border.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(NotificationsFetchRequested());
  }

  void _showNotificationDialog(String detail) {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                detail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Get.height * 0.04),
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        leading: SizedBox(
          height: Get.height * 0.04,
          width: Get.width * 0.05,
          child: SvgPicture.asset(
            "${AppUrl.rootIcons}/notification.svg",
            height: Get.height * 0.04,
            width: Get.width * 0.05,
            fit: BoxFit.scaleDown,
          ),
        ),
        title: Image.asset(
          AppUrl.logo2,
          height: Get.height * 0.07,
          width: Get.width * 0.1,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationsBloc>().add(
                    NotificationsFetchRequested(),
                  );
                },
                child: BlocConsumer<NotificationsBloc, NotificationsState>(
                  listener: (context, state) {
                    if (state is NotificationActionSuccess) {
                      showSuccessSnackbar(message: state.message);
                      context.read<NotificationsBloc>().add(
                        NotificationsFetchRequested(),
                      );
                    } else if (state is NotificationsError) {
                      showErrorSnackbar(message: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is NotificationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is NotificationsLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.notifications.length + 1,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return buildHeader(
                              image: "notification",
                              text: "الإشعارات (${state.unreadCount})",
                            );
                          }

                          final notification = state.notifications[index - 1];
                          return buildJobCard(
                            isViolation: true,
                            index: index - 1,
                            type: notification.title,
                            expiryDate: notification.expiryDate,
                            violation: notification,
                            onTap: () {
                              _showNotificationDialog(notification.detail);
                              if (notification.hasBlueHighlight) {
                                context.read<NotificationsBloc>().add(
                                  NotificationMarkAsRead(index - 1),
                                );
                              }
                            },
                            controller: null,
                            color:
                                notification.hasBlueHighlight
                                    ? AppTheme.blue
                                    : AppTheme.primaryColor,
                            text: notification.type,
                          );
                        },
                      );
                    } else if (state is NotificationsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<NotificationsBloc>().add(
                                  NotificationsFetchRequested(),
                                );
                              },
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    return const Center(child: Text('لا توجد إشعارات'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            final hasUnread =
                state is NotificationsLoaded && state.unreadCount > 0;

            return ButtonBorder(
              height: Get.height * 0.08,
              borderRadius: 15,
              onTap: () {
                if (hasUnread) {
                  context.read<NotificationsBloc>().add(
                    NotificationMarkAllAsRead(),
                  );
                }
              },
              text: "تعليم الكل كمقروء",
              color: hasUnread ? AppTheme.primaryColor : Colors.grey,
              textStyle: TextStyle(
                color: hasUnread ? AppTheme.primaryColor : Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
