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
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.purple, fontSize: 20),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: LoginPage(),
    );
  }
}
