import 'package:flutter/material.dart';

class SlideActionBackground extends StatelessWidget {
  const SlideActionBackground({
    super.key,
    required this.text,
    required this.borderRadius,
  });

  final BorderRadius borderRadius;
  final String text;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.green[50];
    final borderColor = Colors.green[400]!;
    final textColor = Colors.green[800];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontStyle: FontStyle.italic, color: textColor),
        ),
      ),
    );
  }
}
