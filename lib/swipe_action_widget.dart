library swipe_action_widget;

import 'package:flutter/material.dart';

class SwipeActionWidget extends StatefulWidget {
  const SwipeActionWidget({super.key, this.borderRadius});

  final BorderRadius? borderRadius;

  @override
  State<SwipeActionWidget> createState() => _SwipeActionWidgetState();
}

class _SwipeActionWidgetState extends State<SwipeActionWidget> {
  double swipeOffset = _Thumb.width;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(30);
    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: SizedBox(
        height: 50,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              _Background(borderRadius: effectiveBorderRadius),
              ClipRect(
                clipper: _SwipeActionClipper(swipeOffset: swipeOffset),
                child: const _Foreground(),
              ),
              Positioned(
                right: constraints.maxWidth - swipeOffset,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      final newOffset = swipeOffset + details.delta.dx;
                      swipeOffset = newOffset.clamp(
                        _Thumb.width,
                        constraints.maxWidth,
                      );
                    });
                  },
                  child: _Thumb(borderRadius: effectiveBorderRadius),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({super.key, required this.borderRadius});

  final BorderRadius borderRadius;

  static const width = 60.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius.topLeft,
          bottomLeft: borderRadius.bottomLeft,
        ),
        color: const Color.fromRGBO(230, 171, 86, 1),
      ),
      width: width,
      child: const Icon(Icons.keyboard_double_arrow_right),
    );
  }
}

class _SwipeActionClipper extends CustomClipper<Rect> {
  const _SwipeActionClipper({required this.swipeOffset});

  final double swipeOffset;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(swipeOffset, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(_SwipeActionClipper oldClipper) {
    return oldClipper.swipeOffset != swipeOffset;
  }
}

class _Foreground extends StatelessWidget {
  const _Foreground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(247, 230, 184, 1),
      child: const Center(
        child: Text(
          'Swipe to place your order',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({super.key, required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color.fromRGBO(240, 248, 236, 1);
    const borderColor = Color.fromRGBO(174, 198, 163, 1);
    const textColor = Color.fromRGBO(96, 124, 76, 1);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: const Center(
        child: Text(
          'Placing your order...',
          style: TextStyle(fontStyle: FontStyle.italic, color: textColor),
        ),
      ),
    );
  }
}
