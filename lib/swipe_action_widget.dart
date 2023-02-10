library swipe_action_widget;

import 'package:flutter/material.dart';

class SwipeActionWidget extends StatelessWidget {
  const SwipeActionWidget({super.key, this.borderRadius});

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(30);
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        color: const Color.fromRGBO(247, 230, 184, 1),
      ),
      child: const Center(
        child: Text(
          'Swipe to place your order',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
