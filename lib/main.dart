import 'package:degree_verification/screens/get_event_screen.dart';
import 'package:degree_verification/screens/home_screen.dart';
import 'package:degree_verification/screens/publish_screen.dart';
import 'package:degree_verification/screens/verify_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.amber,
      ),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => const HomePage(),
        PublishScreen.id: (context) => const PublishScreen(),
        VerifyScreen.id: (context) => const VerifyScreen(),
        GetEventScreen.id: (context) => const GetEventScreen(),
      },
    );
  }
}
