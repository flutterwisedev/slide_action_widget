import 'package:flutter/material.dart';

class SlideActionThumb extends StatelessWidget {
  const SlideActionThumb({
    super.key,
    required this.borderRadius,
    this.color,
    this.icon = const Icon(Icons.keyboard_double_arrow_right),
    this.width = 60,
  });

  final BorderRadius borderRadius;
  final Color? color;
  final Widget icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius.topLeft,
          bottomLeft: borderRadius.bottomLeft,
        ),
        color: color ?? Colors.indigo.shade100,
      ),
      width: width,
      child: icon,
    );
  }
}
