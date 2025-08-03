import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/question_model.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final String userEmail;
  QuizPage({required this.userEmail});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<QuestionData?> _questionFuture;
  String? selectedAnswer;
  bool hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _questionFuture = FirestoreService().getTodaysQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Quiz")),
      body: FutureBuilder<QuestionData?>(
        future: _questionFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final q = snapshot.data!;
          return FutureBuilder<bool>(
            future: FirestoreService().hasUserAnswered(widget.userEmail, q.id),
            builder: (context, snapshot2) {
              if (!snapshot2.hasData) return CircularProgressIndicator();

              if (snapshot2.data!) {
                return ResultPage(userEmail: widget.userEmail, questionId: q.id);
              }

              return buildQuizUI(q);
            },
          );
        },
      ),
    );
  }

  Widget buildQuizUI(QuestionData q) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(q.questionText, style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          if (q.answerType == 'mcq')
            ...q.choices.map((choice) {
              return RadioListTile<String>(
                title: Text(choice),
                value: choice,
                groupValue: selectedAnswer,
                onChanged: (val) => setState(() => selectedAnswer = val),
              );
            }).toList(),
          if (q.answerType == 'text')
            TextField(
              onChanged: (val) => selectedAnswer = val,
              decoration: InputDecoration(labelText: "Your answer"),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (selectedAnswer == null || hasSubmitted) return;

              await FirestoreService().submitAnswer(
                widget.userEmail,
                q,
                selectedAnswer!,
              );
              setState(() => hasSubmitted = true);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultPage(
                    userEmail: widget.userEmail,
                    questionId: q.id,
                  ),
                ),
              );
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
