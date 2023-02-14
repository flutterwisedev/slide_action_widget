library slide_action_widget;

import 'package:flutter/material.dart';

import 'src/background.dart';
import 'src/foreground.dart';
import 'src/thumb.dart';

export 'src/background.dart';
export 'src/foreground.dart';
export 'src/thumb.dart';

class SlideActionWidget extends StatefulWidget {
  const SlideActionWidget({
    super.key,
    this.borderRadius,
    required this.onComplete,
    this.thumbWidth = 60,
  });

  const SlideActionWidget.custom({
    super.key,
    this.borderRadius,
    required this.onComplete,
    required this.thumbWidth,
  });

  final BorderRadius? borderRadius;
  final VoidCallback onComplete;
  final double thumbWidth;

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
    return SizedBox(
      height: 50,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: LayoutBuilder(builder: (context, constraints) {
          final endPosition = constraints.maxWidth - widget.thumbWidth;
          return Stack(
            children: [
              SlideActionBackground(borderRadius: effectiveBorderRadius),
              AnimatedBuilder(
                animation: _slideOffsetController,
                builder: (context, child) {
                  return ClipRect(
                    clipper: _SlideActionClipper(
                      clipOffset: _slideOffsetController.value * endPosition +
                          widget.thumbWidth,
                    ),
                    child: child,
                  );
                },
                child: const SlideActionForeground(),
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
                child: SlideActionThumb(
                  borderRadius: effectiveBorderRadius,
                  width: widget.thumbWidth,
                ),
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
