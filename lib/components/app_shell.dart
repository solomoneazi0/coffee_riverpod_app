import 'package:flutter/material.dart';
import 'package:riverpod_files/components/navigation_menu.dart';
import 'package:riverpod_files/screens/Wishlist/wishlist_screen.dart';
import 'package:riverpod_files/screens/home/home_screen.dart';
import 'package:riverpod_files/screens/profile/profile_sdreen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 👇 THIS IS THE ACTIVE SCREEN
          _screens[_currentIndex],

          // 👇 THIS IS THE NAV BAR
          NavigationMenu(
            selectedIndex: _currentIndex,
            onChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
