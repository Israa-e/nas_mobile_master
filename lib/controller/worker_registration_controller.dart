import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/registration/page_eight_controller.dart';
import 'package:nas/controller/registration/page_five_controller.dart';
import 'package:nas/controller/registration/page_four_controller.dart';
import 'package:nas/controller/registration/page_nine_controller.dart';
import 'package:nas/controller/registration/page_one_controller.dart';
import 'package:nas/controller/registration/page_seven_controller.dart';
import 'package:nas/controller/registration/page_six_controller.dart';
import 'package:nas/controller/registration/page_ten_controller.dart';
import 'package:nas/controller/registration/page_three_controller.dart';
import 'package:nas/controller/registration/page_two_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/data/models/user_model.dart';
import 'package:nas/presentation/view/screen/Auth/login.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_eight.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_five.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_four.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_nine.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_one.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_seven.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_six.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_ten.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_three.dart';
import 'package:nas/presentation/view/screen/Auth/registration/page_two.dart';
import 'package:nas/presentation/view/widget/button_border.dart';

class WorkerRegistrationController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final int totalPages = 10;

  // Define the pages for the registration flow
  List<Widget> get pages => [
    PageOne(controller: Get.find<PageOneController>()),
    PageTwo(controller: Get.find<PageTwoController>()),
    PageThree(controller: Get.find<PageThreeController>()),
    PageFour(controller: Get.find<PageFourController>()),
    PageFive(controller: Get.find<PageFiveController>()),
    PageSix(controller: Get.find<PageSixController>()),
    PageSeven(controller: Get.find<PageSevenController>()),
    PageEight(controller: Get.find<PageEightController>()),
    PageNine(controller: Get.find<PageNineController>()),
    PageTen(controller: Get.find<PageTenController>()),
  ];
  @override
  void onInit() {
    print("page ${currentPage.value}");
    print("WorkerRegistrationController initialized");
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print("WorkerRegistrationController is ready");

    // Navigate to the first invalid page when the page is re-entered
    navigateToFirstInvalidPage();
  }

  @override
  void onClose() {
    pageController.dispose(); // Dispose of the PageController
    super.onClose();
    print("WorkerRegistrationController is being closed");
  }

  // Navigate to the first invalid page
  void navigateToFirstInvalidPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int page = 0; page < totalPages; page++) {
        if (!validatePageData(page)) {
          if (pageController.hasClients) {
            pageController.jumpToPage(page);
            currentPage.value = page;
            print("Navigating to page $page");
          } else {
            print("PageController is not attached yet.");
          }
          break;
        }
      }
    });
  }

  // Navigate to the next page
  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      if (validateCurrentPage(showSnackbar: true)) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        currentPage.value++;
      } else {}
    }
  }

  // Navigate to the previous page
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      currentPage.value--;
    }
  }

  // Jump to a specific page
  void jumpToPage(int page) {
    if (page >= 0 && page < totalPages) {
      pageController.jumpToPage(page);
    }
  }

  bool validatePageData(int page) {
    if (page < 0 || page >= pageValidators.length) return false;
    return pageValidators[page]();
  }

  // Define all page validators in a list for easy access
  final List<bool Function()> pageValidators = [
    () => Get.find<PageOneController>().validate(showSnackbar: false),
    () => Get.find<PageTwoController>().validate(showSnackbar: false),
    () => Get.find<PageThreeController>().validate(showSnackbar: false),
    () => Get.find<PageFourController>().validate(showSnackbar: false),
    () => Get.find<PageFiveController>().validate(showSnackbar: false),
    () => Get.find<PageSixController>().validate(showSnackbar: false),
    () => Get.find<PageSevenController>().validate(showSnackbar: false),
    () => Get.find<PageEightController>().validate(showSnackbar: false),
    () => Get.find<PageNineController>().validate(showSnackbar: false),
    () => Get.find<PageTenController>().validate(showSnackbar: false),
  ];

  Future<void> handleSwipeBack() async {
    if (currentPage.value == 0) {
      final hasData = Get.find<PageOneController>().hasInputData();
      if (hasData) {
        showBackDialog();
      } else {
        Get.back();
      }
    } else {
      previousPage();
    }
  }

  // Validate the current page
  bool validateCurrentPage({bool showSnackbar = false}) {
    switch (currentPage.value) {
      case 0:
        return Get.find<PageOneController>().validate(
          showSnackbar: showSnackbar,
        );
      case 1:
        return Get.find<PageTwoController>().validate(
          showSnackbar: showSnackbar,
        );
      case 2:
        return Get.find<PageThreeController>().validate(
          showSnackbar: showSnackbar,
        );
      case 3:
        return Get.find<PageFourController>().validate(
          showSnackbar: showSnackbar,
        );
      case 4:
        return Get.find<PageFiveController>().validate(
          showSnackbar: showSnackbar,
        );
      case 5:
        return Get.find<PageSixController>().validate(
          showSnackbar: showSnackbar,
        );
      case 6:
        return Get.find<PageSevenController>().validate(
          showSnackbar: showSnackbar,
        );
      case 7:
        return Get.find<PageEightController>().validate(
          showSnackbar: showSnackbar,
        );
      case 8:
        return Get.find<PageNineController>().validate(
          showSnackbar: showSnackbar,
        );
      case 9:
        return Get.find<PageTenController>().validate(
          showSnackbar: showSnackbar,
        );
      default:
        return false;
    }
  }

  void submitSurvey() async {
    print(currentPage.value);

    if (currentPage.value == totalPages - 1) {
      final userData = {
        ...Get.find<PageOneController>().getFormData(),
        ...Get.find<PageTwoController>().getFormData(),
        ...Get.find<PageThreeController>().getFormData(),
        ...Get.find<PageFourController>().getFormData(),
        ...Get.find<PageFiveController>().getFormData(),
        ...Get.find<PageSixController>().getFormData(),
        ...Get.find<PageSevenController>().getFormData(),
        ...Get.find<PageEightController>().getFormData(),
        ...Get.find<PageNineController>().getFormData(),
        ...Get.find<PageTenController>().getFormData(),
      };

      Future<String?> getDeviceToken() async {
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        // Ask for permission (iOS only)
        await messaging.requestPermission();

        // Get the token
        String? token = await messaging.getToken();
        print("📱 Device Token: $token");
        return token;
        // Store or send it where needed (e.g., database, API)
      }

      final user = UserModel(
        phone: userData['phoneNumber'] ?? '',
        firstName: userData['firstName'] ?? '',
        fatherName: userData['fatherName'] ?? '',
        grandFatherName: userData['grandFatherName'] ?? '',
        familyName: userData['familyName'] ?? '',
        birthDate: userData['birthDate'] ?? '',
        selectedTasks: List<String>.from(userData['selectedTasks'] ?? []),
        workHours: List<String>.from(userData['workHours'] ?? []),
        accountName: userData['accountName'] ?? '',
        accountNumber: userData['accountNumber'] ?? '',
        departmentName: userData['departmentName'] ?? '',
        governorate: userData['governorate'] ?? '',
        district: userData['district'] ?? '',
        location: userData['location'] ?? '',
        nationalId: userData['nationalId'] ?? '',
        nationality: userData['nationality'] ?? '',
        gender: userData['gender'] ?? '',
        maritalStatus: userData['maritalStatus'] ?? '',
        countryCode: userData['countryCode'] ?? '',
        personalImage: userData['personalImage'] ?? '',
        frontIdImage: userData['frontIdImage'] ?? '',
        backIdImage: userData['backIdImage'] ?? '',
        password: userData['password'] ?? '',
        firstContact: userData['firstContact'] ?? {},
        secondContact: userData['secondContact'] ?? {},
        acceptedTerms: userData['acceptedTerms'] ?? false,
        favouriteDays: List<String>.from(userData['favouriteDays'] ?? []),
        favouriteTimes: List<String>.from(userData['favouriteTimes'] ?? []),
        acceptAlcohol: userData['acceptAlcohol'] ?? false,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        token: await getDeviceToken() ?? "",
      );
      final dbUser = {
        'phone': user.phone,
        'firstName': user.firstName,
        'fatherName': user.fatherName,
        'grandFatherName': user.grandFatherName,
        'familyName': user.familyName,
        'birthDate': user.birthDate,
        'accountName': user.accountName,
        'departmentName': user.departmentName,
        'accountNumber': user.accountNumber,
        'workHours': jsonEncode(user.workHours),
        'favouriteDays': jsonEncode(user.favouriteDays),
        'favouriteTimes': jsonEncode(user.favouriteTimes),
        'selectedTasks': jsonEncode(user.selectedTasks),
        'acceptAlcohol': (user.acceptAlcohol == true) ? 1 : 0,
        'governorate': user.governorate,
        'district': user.district,
        'location': user.location,
        'nationalId': user.nationalId,
        'nationality': user.nationality,
        'gender': user.gender,
        'maritalStatus': user.maritalStatus,
        'countryCode': user.countryCode,
        'personalImage': user.personalImage,
        'frontIdImage': user.frontIdImage,
        'backIdImage': user.backIdImage,
        'password': user.password,
        'firstContact': jsonEncode(user.firstContact),
        'secondContact': jsonEncode(user.secondContact),
        'acceptedTerms': jsonEncode(user.acceptedTerms),
        'token': user.token,
        'createdAt': user.createdAt,
      };
      final DatabaseHelper dbHelper = DatabaseHelper.instance;
      await dbHelper.insertUser(dbUser).then((value) {
        print("✅ User inserted with ID: $value");
        showSuccessDialog();
      });
      final addedUser = await dbHelper.getUser(user.phone);
      print("✅ User added: $addedUser");
    } else {
      nextPage();
    }
  }

  void showSuccessDialog() {
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
                  "تم ارسال طلبك بنجاح سوف نقوم بمراجعة الطلب وتفعيل حسابك لمباشرة العمل.انتظر الرد  خلال يومين عمل بحد أقصى",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),

                ButtonBorder(
                  height: 30,
                  borderRadius: 10,

                  onTap: () {
                    Get.back(); // Close the dialog first

                    Get.delete<
                      WorkerRegistrationController
                    >(); // Delete the controller

                    Get.off(() => LoginScreen());
                  },
                  text: "إغلاق",
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showBackDialog() {
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
                  "قد تفقد البيانات التي سجلتها، هل تريد مغادرة الصفحة؟",
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
                        Get.back();
                        Get.back();
                      },
                      text: 'تأكيد',
                      color: AppTheme.red,
                    ),
                    SizedBox(width: 30),
                    ButtonBorder(
                      height: Get.height * 0.04,
                      borderRadius: 10,
                      onTap: () => Get.back(),
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
