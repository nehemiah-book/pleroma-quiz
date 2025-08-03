import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pleroma_bible_quiz/admin/admin_question_editor.dart';
import '../services/firestore_service.dart';
import '../models/result_model.dart';

class ResultPage extends StatelessWidget {
  final String userEmail;
  final String questionId;

  ResultPage({required this.userEmail, required this.questionId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnswerResult>(
      future: FirestoreService().getUserResult(userEmail, questionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final result = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text("Your Result"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  await GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You answered: ${result.userAnswer}",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  result.isCorrect ? "✅ Correct!" : "❌ Wrong.",
                  style: TextStyle(
                    fontSize: 22,
                    color: result.isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Correct answer: ${result.correctAnswer}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
