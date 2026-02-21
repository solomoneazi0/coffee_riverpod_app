import 'package:flutter/material.dart';
import 'package:riverpod_files/screens/onboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> signUp(String email, String password, String fullName) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName}, // send full name as user metadata
      );

      if (response.user != null) {
        return 'User signed up: ${response.user!.email}';
      }

      // 👇 handles the null user case
      return 'Signup successful. Please check your email to confirm.';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return 'User signed in: ${response.user!.email}';
      }

      // 👇 handles the null user case
      return 'Sign-in successful. Welcome back!';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _client.auth.signOut();
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardScreen()),
      );
    } catch (e) {
      // Handle sign-out errors if necessary
      print('Error signing out: $e');
    }
  }
}
