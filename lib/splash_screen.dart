import 'package:flutter/material.dart';
import 'dart:async';
import 'services/native_bridge.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NativeBridge.enableKioskMode();
    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const _LoginRoutePlaceholder(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isKiosk = screenWidth > 1024;

    // Responsive dimensions
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final titleFontSize = isKiosk ? 36.0 : (isTablet ? 30.0 : 24.0);
    final progressSize = isKiosk ? 48.0 : (isTablet ? 42.0 : 36.0);
    final progressStrokeWidth = isKiosk ? 4.0 : 3.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isKiosk ? 400.0 : (isTablet ? 300.0 : 250.0),
                  maxHeight: isKiosk ? 300.0 : (isTablet ? 250.0 : 200.0),
                ),
                child: Image.asset(
                  'assets/images/kiosk_splash.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "TeleMed",
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: progressSize,
                height: progressSize,
                child: CircularProgressIndicator(
                  strokeWidth: progressStrokeWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Lightweight indirection to named route so we can fade to login
class _LoginRoutePlaceholder extends StatelessWidget {
  const _LoginRoutePlaceholder();
  @override
  Widget build(BuildContext context) {
    // Defer to existing named route so route table stays the source of truth
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/loginpage');
    });
    return const SizedBox.shrink();
  }
}
