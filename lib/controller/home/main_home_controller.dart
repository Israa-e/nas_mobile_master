import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/screen/main/approvals_screen.dart';
import 'package:nas/view/screen/main/new_screen.dart';
import 'package:nas/view/screen/main/violations_screen.dart';
import 'package:nas/view/screen/main/waiting_screen.dart';
import 'package:nas/view/widget/button_border.dart';

class MainHomeController extends GetxController
    with GetTickerProviderStateMixin {
  var selectedIndex = 0.obs;
  final PageController pageController = PageController();

  final screens = [
    NewScreen(),
    WaitingScreen(),
    ApprovalsScreen(),
    ViolationsScreen(),
  ];
  AnimationController? drawerAnimationController;
  Animation<Offset>? slideAnimation;
  Animation<double>? fadeAnimation;

  var isDrawerOpen = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize the AnimationController for the drawer
    drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Define the sliding animation
    slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen to the left
      end: Offset.zero, // End at the original position
    ).animate(
      CurvedAnimation(
        parent: drawerAnimationController!,
        curve: Curves.easeInOut,
      ),
    );
    // Add a listener to handle the drawer's state change after the animation completes
    drawerAnimationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Drawer has finished opening
      } else if (status == AnimationStatus.dismissed) {
        // Drawer has finished closing
        isDrawerOpen.value = false;
      }
    });
  }

  // Method to toggle the drawer
  void toggleDrawer() {
    if (isDrawerOpen.value) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
      drawerAnimationController?.reverse();
    } else {
      drawerAnimationController?.forward();
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom],
      ); // إخفاء الجزء العلوي فقط
    }
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  void closeDrawer() {
    if (isDrawerOpen.value) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
      drawerAnimationController?.reverse();
      isDrawerOpen.value = false;
    }
  }

  // Getter to return the currently selected screen
  Widget get currentScreen {
    // Ensure the selectedIndex is within bounds
    if (selectedIndex.value < 0 || selectedIndex.value >= screens.length) {
      return screens[0]; // Default to the first screen if out of bounds
    }
    return screens[selectedIndex.value];
  }

  // Method to change the selected index and animate the page transition
  void changeIndex(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    // Dispose of the PageController and AnimationController
    pageController.dispose();
    drawerAnimationController
        ?.dispose(); // Explicitly dispose the drawer animation controller
    super.onClose();
  }

  Future<bool> showkDialog() async {
    final result = await showBackDialog(); // Corrected variable declaration
    return result ?? false; // Default to false if dialog dismissed
  }

  showBackDialog() {
    Get.dialog(
      Dialog(
        // Add margin to the entire Dialog
        insetPadding: EdgeInsets.symmetric(horizontal: 33),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            // height: 183,
            color: AppTheme.white,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  "هل أنت متأكد أنك تريد مغادرة التطبيق؟",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: Get.height * 0.026),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonBorder(
                      height: Get.height * 0.04,
                      borderRadius: 10,
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      text: 'تأكيد',
                      color: AppTheme.red,
                    ),
                    SizedBox(width: 30),
                    ButtonBorder(
                      height: Get.height * 0.04,
                      borderRadius: 10,
                      onTap: () => Get.back(result: false), // Return false
                      text: "إغلاق",
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
