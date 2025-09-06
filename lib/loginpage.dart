import 'package:flutter/material.dart';
import 'services/action_logger.dart';

class LoginpageWidget extends StatefulWidget {
  const LoginpageWidget({super.key});

  @override
  State<LoginpageWidget> createState() => _LoginpageWidgetState();
}

class _LoginpageWidgetState extends State<LoginpageWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisibility = false;
  bool _isLoading = false;
  static const String _validUsername = 'Telemed';
  static const String _validPassword = 'Telemed@1234';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isKiosk = screenWidth > 1024;

    // Responsive dimensions
    final iconSize = isKiosk ? 160.0 : (isTablet ? 140.0 : 120.0);
    final titleFontSize = isKiosk ? 40.0 : (isTablet ? 36.0 : 32.0);
    final subtitleFontSize = isKiosk ? 20.0 : (isTablet ? 18.0 : 16.0);
    final buttonHeight = isKiosk ? 64.0 : (isTablet ? 60.0 : 56.0);
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final verticalPadding = screenHeight * 0.02; // 2% of screen height

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FBFF),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Medical icon placeholder
                            Container(
                              width: iconSize,
                              height: iconSize,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D8A),
                                borderRadius:
                                    BorderRadius.circular(iconSize / 2),
                              ),
                              child: Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: iconSize * 0.5,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Welcome to TeleMed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2E7D8A),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04),
                                  child: Text(
                                    'Your trusted healthcare companion',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: subtitleFontSize,
                                      color: const Color(0xFF5A9AA8),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextFormField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      hintText: 'Username',
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF7F8C8D),
                                        fontSize: isKiosk ? 18.0 : 16.0,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFDCE7EA),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              isKiosk ? 16.0 : 12.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF2E7D8A),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              isKiosk ? 16.0 : 12.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isKiosk ? 24.0 : 20.0,
                                        vertical: isKiosk ? 20.0 : 16.0,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        color: const Color(0xFF2E7D8A),
                                        size: isKiosk ? 24.0 : 20.0,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: const Color(0xFF2C3E50),
                                      fontSize: isKiosk ? 18.0 : 16.0,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_passwordVisibility,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF7F8C8D),
                                        fontSize: isKiosk ? 18.0 : 16.0,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFDCE7EA),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              isKiosk ? 16.0 : 12.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF2E7D8A),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              isKiosk ? 16.0 : 12.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isKiosk ? 24.0 : 20.0,
                                        vertical: isKiosk ? 20.0 : 16.0,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: const Color(0xFF2E7D8A),
                                        size: isKiosk ? 24.0 : 20.0,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () => setState(() {
                                          _passwordVisibility =
                                              !_passwordVisibility;
                                        }),
                                        child: Icon(
                                          _passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF7F8C8D),
                                          size: isKiosk ? 24.0 : 20.0,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: const Color(0xFF2C3E50),
                                      fontSize: isKiosk ? 18.0 : 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.025),
                            SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        try {
                                          final enteredUser =
                                              _usernameController.text.trim();
                                          final enteredPass =
                                              _passwordController.text;

                                          // Simulate network delay for better UX
                                          await Future.delayed(const Duration(
                                              milliseconds: 500));

                                          if (enteredUser == _validUsername &&
                                              enteredPass == _validPassword) {
                                            // Log successful login
                                            await ActionLogger()
                                                .logLogin(enteredUser);
                                            if (mounted) {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      '/home');
                                            }
                                          } else {
                                            // Log failed login attempt
                                            await ActionLogger().logError(
                                              'login_failed',
                                              'Invalid credentials',
                                              context: {
                                                'username': enteredUser,
                                                'attemptedPassword':
                                                    enteredPass.isNotEmpty
                                                        ? '***'
                                                        : 'empty',
                                              },
                                            );
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Invalid username or password'),
                                                ),
                                              );
                                            }
                                          }
                                        } finally {
                                          if (mounted) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D8A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(isKiosk ? 16.0 : 12.0),
                                    ),
                                  ),
                                  elevation: 2,
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: isKiosk ? 24.0 : 20.0,
                                        height: isKiosk ? 24.0 : 20.0,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isKiosk ? 22.0 : 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.025),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Need help?',
                                  style: TextStyle(
                                    color: const Color(0xFF7F8C8D),
                                    fontSize: isKiosk ? 16.0 : 14.0,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'Contact Support',
                                  style: TextStyle(
                                    color: const Color(0xFF2E7D8A),
                                    fontWeight: FontWeight.w500,
                                    fontSize: isKiosk ? 16.0 : 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Demo: user = Telemed  |  pass = Telemed@1234',
                              style: TextStyle(
                                color: const Color(0xFF7F8C8D),
                                fontSize: isKiosk ? 14.0 : 12.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: isKiosk ? 64.0 : 48.0,
                                  height: isKiosk ? 64.0 : 48.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.local_hospital,
                                    color: const Color(0xFF2E7D8A),
                                    size: isKiosk ? 32.0 : 24.0,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Container(
                                  width: isKiosk ? 64.0 : 48.0,
                                  height: isKiosk ? 64.0 : 48.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.video_call,
                                    color: const Color(0xFF2E7D8A),
                                    size: isKiosk ? 32.0 : 24.0,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Container(
                                  width: isKiosk ? 64.0 : 48.0,
                                  height: isKiosk ? 64.0 : 48.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.health_and_safety,
                                    color: const Color(0xFF2E7D8A),
                                    size: isKiosk ? 32.0 : 24.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              'Secure • Private • Professional',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF95A5A6),
                                fontWeight: FontWeight.w500,
                                fontSize: isKiosk ? 16.0 : 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
