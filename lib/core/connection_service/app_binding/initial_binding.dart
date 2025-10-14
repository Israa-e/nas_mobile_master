// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:nas/controller/forget_password_controller.dart';
import 'package:nas/controller/home/approvals_screen_controller.dart';
import 'package:nas/controller/home/main_home_controller.dart';
import 'package:nas/controller/home/new_screen_controller.dart';
import 'package:nas/controller/home/notification_screen_controller.dart';
import 'package:nas/controller/home/violations_screen_controller.dart';
import 'package:nas/controller/home/waiting_screen_controller.dart';
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
import 'package:nas/controller/worker_registration_controller.dart';
import 'package:nas/controller/login_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // var dio = Dio()
    //   ..options.baseUrl = confing.baseUrlPublic
    //   ..interceptors.add(interceptorsWrapper());

    // Get.put(dio);
    // Get.lazyPut<InstallApi>(() => InstallApi(dio: Get.find()), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
      fenix: true,
    );
    Get.lazyPut<WorkerRegistrationController>(
      () => WorkerRegistrationController(),
      fenix: true,
    );
    Get.lazyPut<PageOneController>(() => PageOneController(), fenix: true);
    Get.lazyPut<PageTwoController>(() => PageTwoController(), fenix: true);
    Get.lazyPut<PageThreeController>(() => PageThreeController(), fenix: true);
    Get.lazyPut<PageFourController>(() => PageFourController(), fenix: true);
    Get.lazyPut<PageFiveController>(() => PageFiveController(), fenix: true);
    Get.lazyPut<PageSixController>(() => PageSixController(), fenix: true);
    Get.lazyPut<PageSevenController>(() => PageSevenController(), fenix: true);
    Get.lazyPut<PageEightController>(() => PageEightController(), fenix: true);
    Get.lazyPut<PageNineController>(() => PageNineController(), fenix: true);
    Get.lazyPut<PageTenController>(() => PageTenController(), fenix: true);
    //home
    Get.lazyPut<MainHomeController>(() => MainHomeController(), fenix: true);
    Get.lazyPut<NewScreenController>(() => NewScreenController(), fenix: true);
    Get.lazyPut<WaitingScreenController>(
      () => WaitingScreenController(),
      fenix: true,
    );
    Get.lazyPut<ApprovalsScreenController>(
      () => ApprovalsScreenController(),
      fenix: true,
    );
    Get.lazyPut<ViolationsScreenController>(
      () => ViolationsScreenController(),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );
  }

  //   InterceptorsWrapper interceptorsWrapper() {
  //     return InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         return handler.next(options); //continue
  //       },
  //       onResponse: (response, handler) {
  //         return handler.next(response); // continue
  //       },
  //       onError: (DioException e, handler) {
  //         if (e.response != null && e.response!.data != null) {}
  //         return handler.next(e); //continue
  //       },
  //     );
  //   }
}
