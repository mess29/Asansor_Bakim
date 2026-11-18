import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Giriş Yap"),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
    );
  }
}
