import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double velocity;
  final Duration pauseDuration;
  final double spacing;

  const MarqueeText({
    super.key,
    required this.text,
    this.style,
    this.velocity = 50.0,
    this.pauseDuration = const Duration(seconds: 3),
    this.spacing = 80.0,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;
  bool _isOverflowing = false;
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  @override
  void didUpdateWidget(MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _isOverflowing = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkOverflow();
      });
    }
  }

  void _checkOverflow() {
    if (!mounted) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final containerWidth = renderBox.size.width;
    _textWidth = textPainter.width;

    if (_textWidth > containerWidth) {
      setState(() {
        _isOverflowing = true;
      });
    } else {
      setState(() {
        _isOverflowing = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOverflowing) {
      return Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return SizedBox(
      height: 30,
        child: Marquee(
        text: widget.text,
        style: widget.style,
        pauseAfterRound: widget.pauseDuration,
        blankSpace: widget.spacing,
        velocity: widget.velocity,
      ),
    );
  }
}