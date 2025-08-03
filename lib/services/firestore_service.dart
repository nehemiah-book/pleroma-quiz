import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<QuestionData?> getTodaysQuestion() async {
    //final istNow = DateTime.now().toUtc();//.add(Duration(hours: 5, minutes: 30));
   // final today = DateFormat('dd-MM-yyyy').format(istNow);

final istNow = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
final startOfDay = DateTime(istNow.year, istNow.month, istNow.day);
final endOfDay = startOfDay.add(Duration(days: 1));
  //   final query = await _firestore.collection('questions')
  //  //   .where('questionDate', isGreaterThanOrEqualTo: today)
  //     .limit(1)
  //     .get();
  //  final query1 = await _firestore.collection('questions')
  //    .where('questionDate', isGreaterThanOrEqualTo: today)
  //     .limit(1)
  //     .get();

 final query = await _firestore.collection('questions')
    .where('questionDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
    .where('questionDate', isLessThan: Timestamp.fromDate(endOfDay))
    .limit(1)
    .get();
    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;
    return QuestionData(
      id: doc.id,
      questionText: doc['questionText'],
      answerType: doc['answerType'],
      correctAnswer: doc['correctAnswer'],
      choices: List<String>.from(doc['choices'] ?? []),
    );
  }

  Future<bool> hasUserAnswered(String email, String questionId) async {
    final query = await _firestore.collection('answers')
      .where('userEmail', isEqualTo: email)
      .where('questionId', isEqualTo: questionId)
      .limit(1)
      .get();

    return query.docs.isNotEmpty;
  }

  Future<void> submitAnswer(String email, QuestionData q, String userAnswer) async {
    final isCorrect = userAnswer.trim().toLowerCase() == q.correctAnswer.trim().toLowerCase();

    await _firestore.collection('answers').add({
      'userEmail': email,
      'questionId': q.id,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'answeredAt': Timestamp.now()
    });
  }

  Future<AnswerResult> getUserResult(String email, String questionId) async {
    final questionSnap = await _firestore.collection('questions').doc(questionId).get();
    final correctAnswer = questionSnap['correctAnswer'];

    final answerSnap = await _firestore.collection('answers')
        .where('userEmail', isEqualTo: email)
        .where('questionId', isEqualTo: questionId)
        .limit(1).get();

    final doc = answerSnap.docs.first;

    return AnswerResult(
      userAnswer: doc['userAnswer'],
      isCorrect: doc['isCorrect'],
      correctAnswer: correctAnswer,
    );
  }
}
