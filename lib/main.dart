import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:nas/presentation/bloc/auth/auth_bloc.dart';
import 'package:nas/presentation/bloc/auth/auth_event.dart';
import 'package:nas/presentation/bloc/jobs/jobs_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:nas/core/connection_service/app_binding/initial_binding.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:nas/presentation/bloc/registration/registration_bloc.dart';
import 'package:nas/presentation/bloc/violations/violations_bloc.dart';
import 'package:nas/presentation/view/screen/splach_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase first
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(AuthCheckStatus())),
        BlocProvider(create: (context) => JobsBloc()),
        BlocProvider(create: (context) => NotificationsBloc()),
        BlocProvider(
          create: (context) {
            final violationsBloc = ViolationsBloc();
            final jobsBloc = context.read<JobsBloc>();

            // Attach listener to connect jobs cancellation to violations
            violationsBloc.attachJobCancellationListener(jobsBloc);

            return violationsBloc;
          },
        ),
        BlocProvider(create: (context) => RegistrationBloc()),
      ],
      child: ScreenUtilInit(
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
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: MediaQuery(
                    data: data.copyWith(textScaleFactor: 1),
                    child: child!,
                  ),
                );
              },

              theme: AppTheme.appTheme,
              initialBinding: InitialBinding(),
              home: const SplashScreen(), // Always start with splash screen
            ),
      ),
    );
  }
}
