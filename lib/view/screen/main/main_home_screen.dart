// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nas/controller/home/main_home_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/screen/main/notification_screen.dart';
import 'package:nas/view/widget/drawer.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainHomeController controller = Get.find<MainHomeController>();
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.changeIndex(0); // التنقل إلى الصفحة الأولى
          return Future.value(false); // منع الرجوع للصفحة السابقة
        }

        if (controller.isDrawerOpen.value) {
          controller.closeDrawer(); // Close the drawer
          return Future.value(false); // Prevent the back action
        } else {
          // If the drawer is not open, show the back dialog
          return controller.showkDialog();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppTheme.white,
            key: _scaffoldKey, // تعيين المفتاح هنا
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Get.to(() => const NotificationScreen());
                },
                child: SizedBox(
                  height: Get.height * 0.04,
                  width: Get.width * 0.05,
                  child: SvgPicture.asset(
                    "${AppUrl.rootIcons}/notification.svg",
                    height: Get.height * 0.04,
                    width: Get.width * 0.05,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              title: Image.asset(
                AppUrl.logo2,
                height: Get.height * 0.06,
                width: Get.width * 0.1,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  onPressed:
                      controller.toggleDrawer, // Toggle the drawer animation
                ),
              ],
            ),

            body: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                controller.selectedIndex.value = index;
              },
              children: controller.screens,
            ),
            bottomNavigationBar: Builder(
              builder: (context) {
                final mediaQuery = MediaQuery.of(context);

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 8 + mediaQuery.viewPadding.bottom,
                  ),
                  child: MediaQuery(
                    data: mediaQuery.removeViewPadding(removeBottom: true),
                    child: Obx(
                      () => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppTheme.white,
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 3,
                          ), // Dynamic border width
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: BottomNavigationBar(
                          selectedItemColor: AppTheme.primaryColor,
                          unselectedItemColor: Colors.grey.withOpacity(0.5),
                          currentIndex: controller.selectedIndex.value,
                          onTap: controller.changeIndex,
                          iconSize: 22,
                          selectedIconTheme: IconThemeData(
                            color: AppTheme.primaryColor,
                            size:
                                Get.height *
                                0.03, // Dynamic size for selected icons
                          ),

                          selectedLabelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                AppTheme
                                    .primaryColor, // Ensure label color is consistent
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                AppTheme
                                    .transparent, // Ensure label color is consistent
                          ),
                          backgroundColor:
                              Colors.transparent, // إزالة لون الخلفية
                          elevation: 0, // إزالة الظل
                          type: BottomNavigationBarType.fixed,
                          items: _buildBottomNavigationBarItems(controller),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: controller.drawerAnimationController!,
            builder: (context, child) {
              // Only render drawer when it's not fully closed
              if (controller.drawerAnimationController!.value == 0.0) {
                return const SizedBox.shrink();
              }

              return SlideTransition(
                position: controller.slideAnimation!,
                child: drawer(controller),
              );
            },
          ),
        ],
      ),
    );
  }
}

List<BottomNavigationBarItem> _buildBottomNavigationBarItems(
  MainHomeController controller,
) {
  final List<Map<String, dynamic>> navItems = [
    {
      "icon": "new.svg",
      "icon_not": "new_not.svg",
      "label": "جديدة",
      "hasNotification": false,
      "isSelected": true,
    },
    {
      "icon": "accept.svg",
      "icon_not": "accept_not.svg",
      "label": "موافقة",
      "hasNotification": true,
      "isSelected": false,
    },
    {
      "icon": "wait.svg",
      "icon_not": "wait_not.svg",
      "label": "إنتظار",
      "hasNotification": true,
      "isSelected": false,
    },
    {
      "icon": "violations.svg",
      "icon_not": "violations_not.svg",
      "label": "مخالفات",
      "hasNotification": true,
      "isSelected": false,
    },
  ];
  return List.generate(
    navItems.length,
    (index) => BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: GestureDetector(
        onTap: () => controller.changeIndex(index),

        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 5),
          child: SvgPicture.asset(
            "${AppUrl.rootIcons}/${navItems[index]['icon']}",
            color:
                controller.selectedIndex.value == index
                    ? AppTheme.primaryColor
                    : Colors.grey,
            height: 22,
            width: 22,
          ),
        ),
      ),
      label: navItems[index]['label'],
    ),
  );
}
