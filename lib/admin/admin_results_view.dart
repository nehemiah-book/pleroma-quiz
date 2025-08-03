import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pleroma_bible_quiz/admin/admin_app_bar.dart';

class AdminResultsView extends StatelessWidget {
  final String userEmail;

  const AdminResultsView({required this.userEmail, Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchAnswers() async {
    final answersSnap = await FirebaseFirestore.instance.collection('answers').get();
    final questionsSnap = await FirebaseFirestore.instance.collection('questions').get();

    final questionMap = {
      for (var doc in questionsSnap.docs) doc.id: doc['questionText'] ?? 'Unknown Question',
    };

    return answersSnap.docs.map((doc) {
      final data = doc.data();
      return {
        'userEmail': data['userEmail'],
        'userAnswer': data['userAnswer'],
        'questionText': questionMap[data['questionId']] ?? 'Deleted Question',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAdminAppBar(context, userEmail),
      
      
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAnswers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final results = snapshot.data!;

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final r = results[index];
              return ListTile(
                title: Text(r['questionText']),
                subtitle: Text("User: ${r['userEmail']} — Answer: ${r['userAnswer']}"),
              );
            },
          );
        },
      ),
    );
  }
}
