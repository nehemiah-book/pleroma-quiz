import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
   await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyChgKMIGVdmPakIdwRaUCZA6hnPd9eFKI8",
        authDomain: "oniro-ooo.firebaseapp.com",
        databaseURL: "https://oniro-ooo.firebaseio.com",
        projectId: "oniro-ooo",
        storageBucket: "oniro-ooo.firebasestorage.app",
        messagingSenderId: "710760252767",
        appId: "1:710760252767:web:56d43dcea8f14a609122ea",
        measurementId: "G-JYG6PZXZSZ",
      ),
    );
    
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}
