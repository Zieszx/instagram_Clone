import 'package:flutter/material.dart';
import 'package:instagram_clone/Screen/sign_In.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/Screen/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(), // Add the sign-up route
      },
    );
  }
}
