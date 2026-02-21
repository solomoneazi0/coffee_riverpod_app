import 'package:flutter/material.dart';
import 'package:riverpod_files/Auth/signup_screen.dart';
// import 'package:riverpod_files/auth/login_screen.dart';
// import 'package:riverpod_files/components/app_shell.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() => animate = true);
    });
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedOpacity(
            opacity: animate ? 1 : 1,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
            child: AnimatedSlide(
              offset: animate ? Offset.zero : const Offset(0, -0.2),
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0, top: 72),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Coffee.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'COFFEE LOVERS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFE8C2),
                        fontFamily: 'ShockedUp',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: AnimatedOpacity(
                  opacity: animate ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/water-splash.png',
                  width: 45,
                  height: 45,
                ),
                const Text(
                  'BREW BETTER CHOOSE SMARTER',
                  style: TextStyle(
                    fontFamily: 'ShockedUp',
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFE8C2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 20, bottom: 34, right: 24, left: 24),
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
                  "Let’s Go!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFE8C2),
                    fontFamily: 'Archivo', // cream text
                  ),
                ),

                // Arrow Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    );
                    // Handle arrow button tap
                  },
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: const BoxDecoration(color: Color(0xFFFFE8C2)),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
