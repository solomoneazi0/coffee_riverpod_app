import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  const EmailTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Archivo',
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'Archivo',
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        prefixIcon: Icon(Icons.email, color: Colors.black),
      ),
    );
  }
}

// another

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Archivo',
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(
          fontSize: 16,
          fontFamily: 'Archivo',
          color: Colors.black,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        prefixIcon: const Icon(Icons.lock, color: Colors.black),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
