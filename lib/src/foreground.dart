import 'package:flutter/material.dart';

class SlideActionForeground extends StatelessWidget {
  const SlideActionForeground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[200],
      child: const Center(
        child: Text('Slide to purchase'),
      ),
    );
  }
}
