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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Medical icon placeholder
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D8A),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: const Icon(
                              Icons.local_hospital,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Welcome to TeleMed',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D8A),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Your trusted healthcare companion',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF5A9AA8),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
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
                                  decoration: const InputDecoration(
                                    hintText: 'Username',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF7F8C8D),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDCE7EA),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF2E7D8A),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF2E7D8A),
                                      size: 20,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF2C3E50),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_passwordVisibility,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF7F8C8D),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDCE7EA),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF2E7D8A),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF2E7D8A),
                                      size: 20,
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
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF2C3E50),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                final enteredUser =
                                    _usernameController.text.trim();
                                final enteredPass = _passwordController.text;
                                if (enteredUser == _validUsername &&
                                    enteredPass == _validPassword) {
                                  // Log successful login
                                  await ActionLogger().logLogin(enteredUser);
                                  if (mounted) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Invalid username or password'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D8A),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Need help?',
                                style: TextStyle(
                                  color: Color(0xFF7F8C8D),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Contact Support',
                                style: TextStyle(
                                  color: Color(0xFF2E7D8A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Demo: user = Telemed  |  pass = Telemed@1234',
                            style: TextStyle(
                              color: Color(0xFF7F8C8D),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F4F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.local_hospital,
                                  color: Color(0xFF2E7D8A),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F4F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.video_call,
                                  color: Color(0xFF2E7D8A),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F4F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.health_and_safety,
                                  color: Color(0xFF2E7D8A),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Secure • Private • Professional',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF95A5A6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
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
