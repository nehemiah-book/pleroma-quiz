import 'package:flutter/material.dart';

class QuizResult extends StatelessWidget {
  final String question;
  final String yourAnswer;
  final String correctAnswer;

  const QuizResult({
    Key? key,
    required this.question,
    required this.yourAnswer,
    required this.correctAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCorrect = yourAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          "Your Answer: $yourAnswer",
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
        const SizedBox(height: 10),
        Text(
          "Correct Answer: $correctAnswer",
          style: TextStyle(fontSize: 18, color: Colors.green),
        ),
        const SizedBox(height: 20),
        Text(
          isCorrect ? "✅ You got it right!" : "❌ That’s incorrect.",
          style: TextStyle(
            fontSize: 20,
            color: isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
