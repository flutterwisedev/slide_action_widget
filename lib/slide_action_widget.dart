library slide_action_widget;

import 'package:flutter/material.dart';

class SlideActionWidget extends StatefulWidget {
  const SlideActionWidget({
    super.key,
    this.borderRadius,
    required this.onComplete,
  });

  final BorderRadius? borderRadius;
  final VoidCallback onComplete;

  @override
  State<SlideActionWidget> createState() => _SlideActionWidgetState();
}

class _SlideActionWidgetState extends State<SlideActionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideOffsetController;

  @override
  void initState() {
    super.initState();
    _slideOffsetController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _slideOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(12);
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
                animation: _slideOffsetController,
                builder: (context, child) {
                  return ClipRect(
                    clipper: _SlideActionClipper(
                      clipOffset: _slideOffsetController.value * endPosition +
                          _Thumb.width,
                    ),
                    child: child,
                  );
                },
                child: const _Foreground(),
              ),
              AnimatedBuilder(
                animation: _slideOffsetController,
                builder: (context, child) {
                  final slideOffset =
                      _slideOffsetController.value * endPosition;
                  void bounceBack() {
                    _slideOffsetController.animateTo(
                      0,
                      curve: Curves.bounceOut,
                      duration: const Duration(milliseconds: 750),
                    );
                  }

                  return Positioned(
                    left: slideOffset,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final slideOffset =
                            _slideOffsetController.value * endPosition;
                        final newOffset = slideOffset + details.delta.dx;
                        _slideOffsetController.value = newOffset / endPosition;
                      },
                      onHorizontalDragEnd: (details) {
                        if (_slideOffsetController.value > .9) {
                          widget.onComplete();
                          _slideOffsetController.animateTo(
                            1,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 200),
                          );
                        } else {
                          bounceBack();
                        }
                      },
                      onHorizontalDragCancel: () => bounceBack(),
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

class _SlideActionClipper extends CustomClipper<Rect> {
  const _SlideActionClipper({required this.clipOffset});

  final double clipOffset;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(clipOffset, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(_SlideActionClipper oldClipper) {
    return oldClipper.clipOffset != clipOffset;
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
        color: Colors.indigo.shade100,
      ),
      width: width,
      child: const Icon(Icons.keyboard_double_arrow_right),
    );
  }
}

class _Foreground extends StatelessWidget {
  const _Foreground({super.key});

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

class _Background extends StatelessWidget {
  const _Background({super.key, required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.green[50];
    final borderColor = Colors.green[400]!;
    final textColor = Colors.green[800];
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Center(
        child: Text(
          'Purchasing...',
          style: TextStyle(fontStyle: FontStyle.italic, color: textColor),
        ),
      ),
    );
  }
}
