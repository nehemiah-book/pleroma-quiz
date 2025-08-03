class QuestionData {
  final String id;
  final String questionText;
  final String answerType;
  final List<String> choices;
  final String correctAnswer;

  QuestionData({
    required this.id,
    required this.questionText,
    required this.answerType,
    required this.choices,
    required this.correctAnswer,
  });
}
