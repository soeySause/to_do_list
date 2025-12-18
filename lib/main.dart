import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/home_page.dart';
import './states/app_sate.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'To Do List App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

