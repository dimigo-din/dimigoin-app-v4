import 'package:flutter/material.dart';

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
    this.spacing = 50.0,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;
  bool _isOverflowing = false;
  double _textWidth = 0;
  bool _isScrolling = false;

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
      _isScrolling = false;
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
      _startScrolling();
    } else {
      setState(() {
        _isOverflowing = false;
      });
    }
  }

  void _startScrolling() async {
    if (_isScrolling || !mounted) return;
    _isScrolling = true;

    // 초기 대기
    await Future.delayed(widget.pauseDuration);

    final scrollDistance = _textWidth + widget.spacing;
    final duration = Duration(
      milliseconds: (scrollDistance / widget.velocity * 1000).round(),
    );

    while (mounted && _isOverflowing && _isScrolling) {
      // 스크롤 애니메이션
      await _scrollController?.animateTo(
        scrollDistance,
        duration: duration,
        curve: Curves.linear,
      );

      if (!mounted || !_isScrolling) break;

      // 처음으로 점프
      _scrollController?.jumpTo(0);

      // 각 사이클 후 pause
      await Future.delayed(widget.pauseDuration);
    }
  }

  @override
  void dispose() {
    _isScrolling = false;
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(
          3,
          (index) => Row(
            children: [
              Text(
                widget.text,
                style: widget.style,
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
              SizedBox(width: widget.spacing),
            ],
          ),
        ),
      ),
    );
  }
}