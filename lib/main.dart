import 'package:chatbot_flutter/src/home_page.dart';
import 'package:chatbot_flutter/widget/pallete.dart';
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
      title: 'Chatbot OpenAI',
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}
