// admin_app_bar.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'admin_question_editor.dart';
import 'admin_results_view.dart';

AppBar buildAdminAppBar(BuildContext context, String userEmail) {
  return AppBar(
    title: Text("Daily Quiz"),
    actions: [
      if (userEmail == 'smk.1590@gmail.com') ...[
        IconButton(
          icon: Icon(Icons.edit_note),
          tooltip: 'Edit Questions',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AdminQuestionEditor(userEmail: userEmail)),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.analytics),
          tooltip: 'View Results',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AdminResultsView(userEmail: userEmail)),
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
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    ],
  );
}
