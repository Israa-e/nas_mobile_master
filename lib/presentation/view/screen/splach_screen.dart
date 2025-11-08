import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/presentation/bloc/auth/auth_bloc.dart';
import 'package:nas/presentation/bloc/auth/auth_state.dart';
import 'package:nas/presentation/view/screen/Auth/login.dart';
import 'package:nas/presentation/view/screen/main/main_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    // Listen to auth state changes
    _navigateBasedOnAuthState();
  }

  void _navigateBasedOnAuthState() {
    // Wait for splash animation to complete (minimum 3 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      _handleNavigation();
    });
  }

  void _handleNavigation() async {
    if (!mounted) return;

    final isLoggedIn = await SharedPrefsHelper.isLoggedIn(); // await here
    print("isLoggedIn: $isLoggedIn");
    if (isLoggedIn) {
      // User is logged in, go to home
      Get.offAll(
        () => const MainHomeScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      // User is not logged in or auth check failed, go to login
      Get.offAll(
        () => const LoginScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = screenHeight * 0.2;
    final fontSize = (screenHeight * 0.04).clamp(20.0, 36.0);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Don't navigate immediately, wait for splash animation
        // Navigation is handled in _navigateBasedOnAuthState
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo with fade-in and scale animation
              FadeInAnimation(
                controller: _controller,
                duration: const Duration(milliseconds: 1200),
                child: Image.asset(
                  AppUrl.logo,
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // First text with slide animation
              SlideInAnimation(
                controller: _controller,
                duration: const Duration(milliseconds: 1500),
                delay: const Duration(milliseconds: 500),
                direction: SlideDirection.right,
                child: Text(
                  "يوم  جديد!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Second text with slide animation
              SlideInAnimation(
                controller: _controller,
                duration: const Duration(milliseconds: 1500),
                delay: const Duration(milliseconds: 1000),
                direction: SlideDirection.left,
                child: Container(
                  margin: const EdgeInsets.only(right: 60.0),
                  child: Text(
                    "شغل جديد!!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Loading indicator
              SizedBox(height: screenHeight * 0.1),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fade-in animation widget
class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final AnimationController controller;

  const FadeInAnimation({
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 800),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: 0.8 + (animation.value * 0.2),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// Direction enum for slide animations
enum SlideDirection { left, right, up, down }

// Slide-in animation widget
class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final SlideDirection direction;
  final AnimationController controller;

  const SlideInAnimation({
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.direction = SlideDirection.left,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Define starting offset based on direction
    Offset startOffset;
    switch (direction) {
      case SlideDirection.left:
        startOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.right:
        startOffset = const Offset(1.0, 0.0);
        break;
      case SlideDirection.up:
        startOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.down:
        startOffset = const Offset(0.0, 1.0);
        break;
    }

    final animation = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay.inMilliseconds / duration.inMilliseconds,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            animation.value.dx * MediaQuery.of(context).size.width,
            animation.value.dy * MediaQuery.of(context).size.height,
          ),
          child: Opacity(opacity: controller.value, child: child),
        );
      },
      child: child,
    );
  }
}
