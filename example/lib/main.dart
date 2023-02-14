import 'package:flutter/material.dart';
import 'package:slide_action_widget/slide_action_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide action widget Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(body: Body()),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SlideActionWidget(
          onComplete: () {
            print('Completed');
          },
        ),
      ),
    );
  }
}
