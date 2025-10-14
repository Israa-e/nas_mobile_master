import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/controller/splash_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = screenHeight * 0.2;
    final fontSize = (screenHeight * 0.04).clamp(20.0, 36.0);

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo with fade-in and scale animation
            FadeInAnimation(
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
          ],
        ),
      ),
    );
  }
}

// Simple fade-in animation widget
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const FadeInAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    super.key,
  });

  @override
  FadeInAnimationState createState() => FadeInAnimationState();
}

class FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.scale(
            scale: 0.8 + (_animation.value * 0.2),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

// Direction enum for slide animations
enum SlideDirection { left, right, up, down }

// Simple slide-in animation widget
class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final SlideDirection direction;

  const SlideInAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.direction = SlideDirection.left,
    super.key,
  });

  @override
  SlideInAnimationState createState() => SlideInAnimationState();
}

class SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Define starting offset based on direction
    Offset startOffset;
    switch (widget.direction) {
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

    _animation = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: FadeTransition(opacity: _controller, child: widget.child),
    );
  }
}
