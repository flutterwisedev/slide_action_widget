library swipe_action_widget;

import 'package:flutter/material.dart';

class SwipeActionWidget extends StatefulWidget {
  const SwipeActionWidget({super.key, this.borderRadius});

  final BorderRadius? borderRadius;

  @override
  State<SwipeActionWidget> createState() => _SwipeActionWidgetState();
}

class _SwipeActionWidgetState extends State<SwipeActionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swipeOffsetController;

  @override
  void initState() {
    super.initState();
    _swipeOffsetController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _swipeOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(30);
    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: SizedBox(
        height: 50,
        child: LayoutBuilder(builder: (context, constraints) {
          final endPosition = constraints.maxWidth - _Thumb.width;
          return Stack(
            children: [
              _Background(borderRadius: effectiveBorderRadius),
              AnimatedBuilder(
                animation: _swipeOffsetController,
                builder: (context, child) {
                  return ClipRect(
                    clipper: _SwipeActionClipper(
                      swipeOffset: _swipeOffsetController.value * endPosition,
                    ),
                    child: child,
                  );
                },
                child: const _Foreground(),
              ),
              AnimatedBuilder(
                animation: _swipeOffsetController,
                builder: (context, child) {
                  final swipeOffset =
                      _swipeOffsetController.value * endPosition;
                  return Positioned(
                    left: swipeOffset,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final swipeOffset =
                            _swipeOffsetController.value * endPosition;
                        final newOffset = swipeOffset + details.delta.dx;
                        _swipeOffsetController.value = newOffset / endPosition;
                      },
                      child: child,
                    ),
                  );
                },
                child: _Thumb(borderRadius: effectiveBorderRadius),
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
    return Rect.fromLTWH(
      swipeOffset + _Thumb.width,
      0,
      size.width,
      size.height,
    );
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
