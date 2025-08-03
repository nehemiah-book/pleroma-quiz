import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'quiz_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Login with Google"),
          onPressed: () async {
            final user = await AuthService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => QuizScreen(userEmail: user.email!)),
              );
            }
          },
        ),
      ),
    );
  }
}
