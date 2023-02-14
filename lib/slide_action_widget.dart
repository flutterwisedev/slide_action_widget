library slide_action_widget;

import 'package:flutter/material.dart';

import 'src/background.dart';
import 'src/foreground.dart';
import 'src/thumb.dart';

export 'src/background.dart';
export 'src/foreground.dart';
export 'src/thumb.dart';

/// A [Widget] that allows the user to slide a [thumb] across a [foreground],
/// slowly revealing the [background], and then enacting [onComplete] after
/// releasing the [thumb] in the end position.
class SlideActionWidget extends StatefulWidget {
  /// Creates the default [SlideActionWidget].
  ///
  /// [onComplete] is called when the user releases the [thumb] within 10% of
  /// the end of the slide. Otherwise, the [thumb] will snap back to the
  /// starting position.
  ///
  /// Example:
  /// ```dart
  /// SlideActionWidget(
  ///   backgroundText: 'Purchasing...',
  ///   foregroundText: 'Slide to purchase',
  ///   onComplete: () {
  ///     print('Purchased');
  ///   },
  /// ),
  /// ```
  SlideActionWidget({
    super.key,
    String backgroundText = 'Purchasing...',
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    String foregroundText = 'Slide to purchase',
    this.height = 50,
    required this.onComplete,
    this.snapCurve = Curves.bounceOut,
    this.thumbWidth = 60,
  })  : background = SlideActionBackground(
          borderRadius: borderRadius,
          text: backgroundText,
        ),
        foreground = SlideActionForeground(text: foregroundText),
        thumb = SlideActionThumb(borderRadius: borderRadius, width: thumbWidth);

  /// Useful for creating a [SlideActionWidget] with a custom
  /// [SlideActionBackground], [SlideActionForeground], or [SlideActionThumb].
  ///
  /// Example:
  /// ```dart
  /// SlideActionWidget.custom(
  ///   background: Container(
  ///     color: Colors.red.shade200,
  ///     child: Center(
  ///       child: Text(
  ///         'Deleting...',
  ///         style: TextStyle(
  ///           color: Colors.red.shade900,
  ///           fontStyle: FontStyle.italic,
  ///         ),
  ///       ),
  ///     ),
  ///   ),
  ///   foreground: Container(
  ///     color: Colors.orangeAccent.shade100,
  ///     child: const Center(child: Text('Slide to delete')),
  ///   ),
  ///   thumb: SlideActionThumb(
  ///     width: 60,
  ///     color: Colors.red.shade300,
  ///     borderRadius: BorderRadius.circular(12),
  ///     icon: const Icon(Icons.delete),
  ///   ),
  ///   onComplete: () {
  ///     print('Deleted');
  ///   },
  /// ),
  SlideActionWidget.custom({
    super.key,
    Widget? background,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    Widget? foreground,
    this.height = 50,
    required this.onComplete,
    this.snapCurve = Curves.bounceOut,
    Widget? thumb,
    this.thumbWidth = 60,
  })  : background = background ??
            SlideActionBackground(
              borderRadius: borderRadius,
              text: 'Purchasing...',
            ),
        foreground = foreground ??
            const SlideActionForeground(text: 'Slide to purchase'),
        thumb = thumb ??
            SlideActionThumb(borderRadius: borderRadius, width: thumbWidth);

  /// The widget displayed behind the [foreground].
  ///
  /// It is revealed as the user drags the [thumb] to the end position.
  final Widget background;

  /// The border radius of the [background], [foreground], and [thumb].
  final BorderRadius borderRadius;

  /// The widget displayed in front of the [background].
  ///
  /// It is hidden as the user drags the [thumb] to the end position.
  final Widget foreground;

  /// The height of the [SlideActionWidget].
  final double height;

  /// Called when the user releases the [thumb] within 10% of the end of the
  /// end position.
  final VoidCallback onComplete;

  /// The curve used to animate the [thumb] back to the starting position after
  /// the user releases the [thumb], assuming they didn't slide it all the way
  /// across.
  final Curve snapCurve;

  /// The [Widget] that the user drags from start to finish to complete the
  /// action.
  final Widget thumb;

  /// The width of the [thumb].
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
    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: LayoutBuilder(builder: (context, constraints) {
          final endPosition = constraints.maxWidth - widget.thumbWidth;
          return Stack(
            children: [
              widget.background,
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
                child: widget.foreground,
              ),
              AnimatedBuilder(
                animation: _slideOffsetController,
                builder: (context, child) {
                  final slideOffset =
                      _slideOffsetController.value * endPosition;
                  void snapBack() {
                    _slideOffsetController.animateTo(
                      0,
                      curve: widget.snapCurve,
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
                          snapBack();
                        }
                      },
                      onHorizontalDragCancel: () => snapBack(),
                      child: child,
                    ),
                  );
                },
                child: widget.thumb,
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
