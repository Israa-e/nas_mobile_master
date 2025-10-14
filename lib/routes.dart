import 'package:flutter/material.dart';

import 'package:nas/core/constant/routes.dart';
import 'package:nas/view/screen/Auth/worker_registration_screen.dart';
import 'package:nas/view/screen/Auth/login.dart';
import 'package:nas/view/screen/main/drawer/change_password.dart';
import 'package:nas/view/screen/main/drawer/change_wallet_number.dart';
import 'package:nas/view/screen/main/drawer/edit_phone_number.dart';
import 'package:nas/view/screen/main/drawer/job_selection_screen.dart';
import 'package:nas/view/screen/main/drawer/modify_working_hours.dart';
import 'package:nas/view/screen/main/location.dart';
import 'package:nas/view/screen/main/main_home_screen.dart';
import 'package:nas/view/screen/main/notification_screen.dart';
import 'package:nas/view/screen/splach_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.splash: (context) => const SplashScreen(),
  AppRoute.login: (context) => const LoginScreen(),
  AppRoute.workerRegistration: (context) => const WorkerRegistrationScreen(),
  AppRoute.notification: (context) => const NotificationScreen(),
  AppRoute.mainHome: (context) => const MainHomeScreen(),

  AppRoute.location: (context) => const Location(),
  AppRoute.drawerJobSelection: (context) => JobSelectionScreen(),
  AppRoute.modifyWorkingHours: (context) => ModifyWorkingHours(),
  AppRoute.changeWalletNumber: (context) => ChangeWalletNumber(),
  AppRoute.changePassword: (context) => ChangePassword(),
  AppRoute.editPhoneNumber: (context) => EditPhoneNumber(),
};
