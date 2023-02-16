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
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Example #1
              SlideActionWidget(
                backgroundText: 'Purchasing...',
                foregroundText: 'Slide to purchase',
                onComplete: () {
                  print('Purchased');
                },
              ),
              const SizedBox(height: 12),
              // Example #2
              SlideActionWidget(
                backgroundText: 'Sending',
                foregroundText: 'Slide to send',
                onComplete: () {
                  print('Sent');
                },
              ),
              const SizedBox(height: 12),

              // Example #3
              SlideActionWidget.custom(
                background: Container(
                  color: Colors.red.shade100,
                  child: Center(
                    child: Text(
                      'Deleting...',
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                foreground: Container(
                  color: Colors.orangeAccent.shade100,
                  child: const Center(child: Text('Slide to delete')),
                ),
                thumb: SlideActionThumb(
                  width: 60,
                  color: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(12),
                  icon: const Icon(Icons.delete),
                ),
                onComplete: () {
                  print('Deleted');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
