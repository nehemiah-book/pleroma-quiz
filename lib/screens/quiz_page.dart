import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../models/quiz_result.dart';
import 'result_page.dart';
import 'quiz_question_widget.dart';
import '../admin/admin_question_editor.dart';
import '../admin/admin_results_view.dart';

class QuizScreen extends StatefulWidget {
  final String userEmail;
  const QuizScreen({required this.userEmail, Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _questionDoc;
  bool _hasAnswered = false;
  String? _userAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestionAndAnswer();
  }

  Future<void> _loadQuestionAndAnswer() async {
    final istNow = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
    final startOfDay = DateTime(istNow.year, istNow.month, istNow.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final questionSnap = await _firestore
        .collection('questions')
        .where(
          'questionDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('questionDate', isLessThan: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    if (questionSnap.docs.isEmpty) {
      setState(() {
        _questionDoc = null;
      });
      return;
    }

    final questionDoc = questionSnap.docs.first;
    final answersSnap = await _firestore
        .collection('answers')
        .where('userEmail', isEqualTo: widget.userEmail)
        .where('questionId', isEqualTo: questionDoc.id)
        .get();

    if (answersSnap.docs.isNotEmpty) {
      setState(() {
        _questionDoc = questionDoc;
        _hasAnswered = true;
        _userAnswer = answersSnap.docs.first['userAnswer'];
      });
    } else {
      setState(() {
        _questionDoc = questionDoc;
      });
    }
  }

  void _onAnswerSubmit(String answer) async {
    await _firestore.collection('answers').add({
      'questionId': _questionDoc!.id,
      'userEmail': widget.userEmail,
      'userAnswer': answer,
      'answeredAt': Timestamp.now(),
    });

    setState(() {
      _hasAnswered = true;
      _userAnswer = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Quiz"),
        actions: [
          if (widget.userEmail == 'smk.1590@gmail.com') ...[
            IconButton(
              icon: Icon(Icons.edit_note),
              tooltip: 'Edit Questions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminQuestionEditor(userEmail: widget.userEmail),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.analytics),
              tooltip: 'View Results',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminResultsView(userEmail: widget.userEmail),
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
        ],
      ),
      body: _questionDoc == null
          ? Center(
              child: Text(
                "No questions today.",
                style: TextStyle(fontSize: 20),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _hasAnswered
                  ? QuizResult(
                      question: _questionDoc!['questionText'],
                      yourAnswer: _userAnswer!,
                      correctAnswer: _questionDoc!['correctAnswer'],
                    )
                  : QuizQuestionWidget(
                      questionData:
                          _questionDoc!.data() as Map<String, dynamic>,
                      onSubmit: _onAnswerSubmit,
                    ),
            ),
    );
  }
}
