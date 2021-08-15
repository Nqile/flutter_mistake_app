import 'package:flutter/material.dart';
import 'package:flutter_mistake_app/pages/homePage.dart';
import 'package:flutter_mistake_app/storage/subject_simple_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SubjectSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mistake Compiler'),
    );
  }
}
