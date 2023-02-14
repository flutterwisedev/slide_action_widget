import 'package:flutter/material.dart';

class SlideActionForeground extends StatelessWidget {
  const SlideActionForeground({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[200],
      child: Center(
        child: Text(text),
      ),
    );
  }
}
