import 'package:flutter/material.dart';
import 'package:swipe_action_widget/swipe_action_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe action widget Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(body: Body()),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: SwipeActionWidget(),
      ),
    );
  }
}
