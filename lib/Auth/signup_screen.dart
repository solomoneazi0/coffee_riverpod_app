import 'package:flutter/material.dart';
import 'package:riverpod_files/Service/auth_service.dart';
import 'package:riverpod_files/components/app_shell.dart';
import 'package:riverpod_files/components/emailtextfield.dart';
import 'package:riverpod_files/components/snack_bar.dart';
import 'package:riverpod_files/components/oauth_buttons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool rememberMe = false;
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!email.contains('@') || !email.contains('.')) {
      showCustomSnackBar(context, 'Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      showCustomSnackBar(context, 'Password must be at least 6 characters.');
      return;
    }

    setState(() => _isLoading = true);
    final result = await _authService.signUp(email, password);
    setState(() => _isLoading = false);

    if (result != null) {
      showCustomSnackBar(context, result);
    } else {
      // Signup successful, navigate to home (AppShell)
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AppShell()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 64.0, right: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Image.asset(
          //         'assets/images/Coffee.png',
          //         width: 24,
          //         height: 24,
          //       ),
          //       const SizedBox(width: 8),
          //       const Text(
          //         'COFFEE LOVERS',
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //           color: Color(0xFFFFE8C2),
          //           fontFamily: 'ShockedUp',
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Image.asset(
                    'assets/images/onboardimage.png',
                    width: 220,
                    height: 220,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                height: 400,
                width: double.infinity,
                color: const Color(0xFFFFE8C2).withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                            fontSize: 42, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 32),

                      // Add your login form fields here (e.g., TextFields for email and password)

                      EmailTextField(controller: emailController),

                      const SizedBox(height: 16),

                      PasswordTextField(controller: passwordController),

                      const SizedBox(height: 20),

                      // Sign up / submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // 👈 no radius
                            ),
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _isLoading ? null : _handleSignUp,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 👈 Remember me
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                                activeColor: Colors.black,
                                side: const BorderSide(
                                    color: Colors.black, width: 2),

                                visualDensity:
                                    VisualDensity.compact, // 👈 reduces spacing
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Archivo',
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromARGB(255, 42, 42, 42),
                                ),
                              ),
                            ],
                          ),

                          // 👉 Forgot password
                          GestureDetector(
                            onTap: () {
                              // TODO: navigate to forgot password screen
                            },
                            child: const Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Archivo',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // OAuth Sign-In Buttons
                      OAuthButtons(
                        onSignInSuccess: (provider, userData) {
                          showCustomSnackBar(
                            context,
                            'Successfully signed in with $provider',
                          );
                          // TODO: Handle successful OAuth sign-in
                          // You can pass the userData to your auth service or navigate to next screen
                        },
                        onSignInError: (error) {
                          showCustomSnackBar(context, error);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 24, right: 24, left: 24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFFFE8C2).withOpacity(0.6),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFE8C2),
                      fontFamily: 'Archivo', // cream text
                    ),
                  ),

                  // Arrow Button
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   // MaterialPageRoute(builder: (context) => const AppShell()),
                      // );
                      // Handle arrow button tap
                    },
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFE8C2)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
