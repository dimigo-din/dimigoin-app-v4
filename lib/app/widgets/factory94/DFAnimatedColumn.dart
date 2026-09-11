import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A column whose children fade and slide into place one after another.
///
/// The animation starts automatically when the widget is first inserted into
/// the tree. Its total duration grows when necessary so every child receives
/// the full [itemDuration].
class DFAnimatedColumn extends StatefulWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration itemDelay;
  final Duration minimumDuration;
  final Curve curve;
  final Offset beginOffset;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final double spacing;

  const DFAnimatedColumn({
    super.key,
    required this.children,
    this.itemDuration = const Duration(milliseconds: 300),
    this.itemDelay = const Duration(milliseconds: 50),
    this.minimumDuration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, 0.3),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
  }) : assert(spacing >= 0.0);

  @override
  State<DFAnimatedColumn> createState() => _DFAnimatedColumnState();
}

class _DFAnimatedColumnState extends State<DFAnimatedColumn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Duration get _totalDuration {
    final staggeredDuration = widget.children.isEmpty
        ? Duration.zero
        : widget.itemDuration + widget.itemDelay * (widget.children.length - 1);

    return Duration(
      microseconds: math.max(
        widget.minimumDuration.inMicroseconds,
        staggeredDuration.inMicroseconds,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    assert(_hasValidDurations);
    _controller = AnimationController(vsync: this, duration: _totalDuration)
      ..forward();
  }

  @override
  void didUpdateWidget(covariant DFAnimatedColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(_hasValidDurations);
    _controller.duration = _totalDuration;
  }

  bool get _hasValidDurations {
    assert(
      widget.itemDuration.inMicroseconds > 0,
      'itemDuration must be greater than zero.',
    );
    assert(!widget.itemDelay.isNegative, 'itemDelay must not be negative.');
    assert(
      widget.minimumDuration.inMicroseconds > 0,
      'minimumDuration must be greater than zero.',
    );
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMicroseconds = _totalDuration.inMicroseconds;

    return Column(
      mainAxisAlignment: widget.mainAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      crossAxisAlignment: widget.crossAxisAlignment,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      textBaseline: widget.textBaseline,
      spacing: widget.spacing,
      children: List.generate(widget.children.length, (index) {
        final start =
            (widget.itemDelay.inMicroseconds * index) / totalMicroseconds;
        final end =
            (widget.itemDelay.inMicroseconds * index +
                widget.itemDuration.inMicroseconds) /
            totalMicroseconds;
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: widget.curve),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: widget.beginOffset,
              end: Offset.zero,
            ).animate(animation),
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}
