import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:nas/core/connection_service/app_binding/initial_binding.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/view/screen/splach_screen.dart';

import 'data/fcm_api.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            transitionDuration: const Duration(milliseconds: 500),
            defaultTransition: Transition.leftToRight,
            title: 'NAS',
            locale: Locale('ar'), // Default language
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaleFactor: 1),
                child: child!,
              );
            },
            theme: AppTheme.appTheme,
            textDirection: TextDirection.rtl,
            initialBinding: InitialBinding(),
            home: const SplashScreen(), // Replace with your initial screen
          ),
    );
  }
}
