import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pleroma_bible_quiz/admin/admin_app_bar.dart';

class AdminQuestionEditor extends StatefulWidget {
  //const AdminQuestionEditor({Key? key}) : super(key: key);

  final String userEmail;

  const AdminQuestionEditor({required this.userEmail, Key? key}) : super(key: key);

  @override
  State<AdminQuestionEditor> createState() => _AdminQuestionEditorState();
}

class _AdminQuestionEditorState extends State<AdminQuestionEditor> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30))),
  );
  final List<TextEditingController> choiceControllers = List.generate(4, (_) => TextEditingController());

  String answerType = 'mcq';
   

  void saveQuestion() async {
    final firestore = FirebaseFirestore.instance;
    final question = questionController.text.trim();
    final correctAnswer = correctAnswerController.text.trim();
    final questionDate = dateController.text.trim();

    if (question.isEmpty || correctAnswer.isEmpty || questionDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fill all required fields")));
      return;
    }

    List<String> choices = answerType == 'mcq'
        ? choiceControllers.map((c) => c.text.trim()).where((c) => c.isNotEmpty).toList()
        : [];

    await firestore.collection('questions').add({
      'questionText': question,
      'correctAnswer': correctAnswer,
      'questionDate': questionDate,
      'answerType': answerType,
      'choices': choices,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Question saved")));
    questionController.clear();
    correctAnswerController.clear();
    choiceControllers.forEach((c) => c.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAdminAppBar(context, widget.userEmail),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question Date (yyyy-MM-dd):"),
            TextField(controller: dateController),

            SizedBox(height: 20),
            Text("Question Text:"),
            TextField(controller: questionController, maxLines: 2),

            SizedBox(height: 20),
            Text("Correct Answer:"),
            TextField(controller: correctAnswerController),

            SizedBox(height: 20),
            DropdownButton<String>(
              value: answerType,
              onChanged: (val) => setState(() => answerType = val!),
              items: ['mcq', 'text'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type.toUpperCase()));
              }).toList(),
            ),

            if (answerType == 'mcq')
              Column(
                children: List.generate(choiceControllers.length, (i) {
                  return TextField(
                    controller: choiceControllers[i],
                    decoration: InputDecoration(labelText: 'Choice ${i + 1}'),
                  );
                }),
              ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: saveQuestion, child: Text("Save Question")),
          ],
        ),
      ),
    );
  }
}
