import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:riverpod_files/components/snack_bar.dart';

// Reusable sign up functions for Google and Facebook
Future<Map<String, dynamic>> signUpWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  if (googleUser == null) throw Exception('Google sign-in cancelled');
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  return {
    'id': googleUser.id,
    'email': googleUser.email,
    'displayName': googleUser.displayName,
    'photoUrl': googleUser.photoUrl,
    'idToken': googleAuth.idToken,
    'accessToken': googleAuth.accessToken,
  };
}

Future<Map<String, dynamic>> signUpWithFacebook() async {
  final LoginResult result = await FacebookAuth.instance.login(
    permissions: ['email', 'public_profile'],
  );
  if (result.status == LoginStatus.success) {
    final AccessToken accessToken = result.accessToken!;
    final userData = await FacebookAuth.instance.getUserData(
      fields: 'id,name,email,picture',
    );
    return {
      'id': userData['id'],
      'email': userData['email'],
      'displayName': userData['name'],
      'photoUrl': userData['picture']?['data']?['url'],
      'accessToken': accessToken.token,
    };
  } else if (result.status == LoginStatus.cancelled) {
    throw Exception('Facebook sign-in cancelled');
  } else {
    throw Exception(result.message ?? 'Facebook login failed');
  }
}

class OAuthButtons extends StatefulWidget {
  final Function(String provider, Map<String, dynamic> userData)?
      onSignInSuccess;
  final Function(String error)? onSignInError;

  const OAuthButtons({
    super.key,
    this.onSignInSuccess,
    this.onSignInError,
  });

  @override
  State<OAuthButtons> createState() => _OAuthButtonsState();
}

class _OAuthButtonsState extends State<OAuthButtons> {
  bool _isLoadingGoogle = false;
  bool _isLoadingFacebook = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
  ]);

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _isLoadingGoogle = true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final userData = {
          'id': googleUser.id,
          'email': googleUser.email,
          'displayName': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
          'idToken': googleAuth.idToken,
          'accessToken': googleAuth.accessToken,
        };

        widget.onSignInSuccess?.call('google', userData);
        if (mounted) {
          showCustomSnackBar(
              context, 'Signed in with Google: ${googleUser.email}');
        }
      }
    } catch (error) {
      final errorMsg = 'Google Sign-In failed: $error';
      widget.onSignInError?.call(errorMsg);
      if (mounted) {
        showCustomSnackBar(context, errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingGoogle = false);
      }
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      setState(() => _isLoadingFacebook = true);

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final userData = await FacebookAuth.instance.getUserData(
          fields: 'id,name,email,picture',
        );

        final userProfile = {
          'id': userData['id'],
          'email': userData['email'],
          'displayName': userData['name'],
          'photoUrl': userData['picture']?['data']?['url'],
          'accessToken': accessToken.token,
        };

        widget.onSignInSuccess?.call('facebook', userProfile);
        if (mounted) {
          showCustomSnackBar(
              context, 'Signed in with Facebook: ${userData['email']}');
        }
      } else if (result.status == LoginStatus.cancelled) {
        if (mounted) {
          showCustomSnackBar(context, 'Facebook Sign-In cancelled');
        }
      } else {
        throw Exception(result.message ?? 'Facebook login failed');
      }
    } catch (error) {
      final errorMsg = 'Facebook Sign-In failed: $error';
      widget.onSignInError?.call(errorMsg);
      if (mounted) {
        showCustomSnackBar(context, errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingFacebook = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.black26,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Or continue with',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 42, 42, 42),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // OAuth buttons row
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Google Sign-In Button
            _OAuthButton(
              icon: FontAwesomeIcons.google,
              label: 'Sign up with Google',
              isLoading: _isLoadingGoogle,
              backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.7),
              iconColor: const Color(0xFF4285F4),
              onPressed: _signInWithGoogle,
            ),
            // Facebook Sign-In Button
            _OAuthButton(
              icon: FontAwesomeIcons.facebook,
              label: 'Sign up with Facebook',
              isLoading: _isLoadingFacebook,
              backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.7),
              iconColor: const Color(0xFF1877F2),
              onPressed: _signInWithFacebook,
            ),
          ],
        ),
      ],
    );
  }
}

class _OAuthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLoading;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onPressed;

  const _OAuthButton({
    required this.icon,
    required this.label,
    required this.isLoading,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: Colors.black12,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: double.infinity,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                      ),
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            icon,
                            size: 24,
                            color: iconColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 42, 42, 42),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
