import 'package:flutter/material.dart';

class QuizQuestionWidget extends StatefulWidget {
  final Map<String, dynamic> questionData;
  final Function(String answer) onSubmit;

  const QuizQuestionWidget({
    Key? key,
    required this.questionData,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<QuizQuestionWidget> createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  String? selectedAnswer;
  final TextEditingController textController = TextEditingController();
  bool submitted = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final answer = widget.questionData['answerType'] == 'text'
        ? textController.text.trim()
        : selectedAnswer;

    if (answer == null || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter or select your answer.")),
      );
      return;
    }

    setState(() {
      submitted = true;
    });

    widget.onSubmit(answer);
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questionData;
    final answerType = q['answerType'];
    final choices = List<String>.from(q['choices'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q['questionText'] ?? '',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        if (answerType == 'mcq')
          ...choices.map((c) => RadioListTile<String>(
                title: Text(c),
                value: c,
                groupValue: selectedAnswer,
                onChanged: (val) {
                  setState(() {
                    selectedAnswer = val;
                  });
                },
              )),

        if (answerType == 'text')
          TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'Your answer',
              border: OutlineInputBorder(),
            ),
          ),

        const SizedBox(height: 20),

        if (!submitted)
          Center(
            child: ElevatedButton(
              onPressed: _handleSubmit,
              child: Text("Submit"),
            ),
          ),
      ],
    );
  }
}
