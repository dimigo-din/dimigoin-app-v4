import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class DFGestureDetectorWithFillInteraction extends StatefulWidget {
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Duration duration;
  final Widget child;
  final EdgeInsets effectPadding;
  final double effectBorderRadius;

  const DFGestureDetectorWithFillInteraction({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    this.effectPadding = EdgeInsets.zero,
    this.effectBorderRadius = 0,
  });

  @override
  State<DFGestureDetectorWithFillInteraction> createState() =>
      _DFGestureDetectorWithFillInteractionState();
}

class _DFGestureDetectorWithFillInteractionState
    extends State<DFGestureDetectorWithFillInteraction> {
  bool isPressed = false;

  void pressUp() {
    if (widget.onTap == null && widget.onLongPress == null) {
      return;
    }
    setState(() {
      isPressed = false;
    });
  }

  void pressDown() {
    if (widget.onTap == null && widget.onLongPress == null) {
      return;
    }
    setState(() {
      isPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    DFColors colorTheme = Theme.of(context).extension<DFColors>()!;
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapCancel: pressUp,
      child: Listener(
        onPointerDown: (_) => pressDown(),
        onPointerUp: (_) => pressUp(),
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: isPressed ? 0.05 : 0,
                  duration: widget.duration,
                  child: Container(
                    margin: widget.effectPadding,
                    decoration: BoxDecoration(
                      color: colorTheme.contentStandardPrimary,
                      borderRadius:
                          BorderRadius.circular(widget.effectBorderRadius),
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

class DFGestureDetectorWithOpacityInteraction extends StatefulWidget {
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Duration duration;
  final Widget child;

  const DFGestureDetectorWithOpacityInteraction({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<DFGestureDetectorWithOpacityInteraction> createState() =>
      _DFGestureDetectorWithOpacityInteractionState();
}

class _DFGestureDetectorWithOpacityInteractionState
    extends State<DFGestureDetectorWithOpacityInteraction> {
  bool isPressed = false;

  void pressUp() {
    if (widget.onTap == null && widget.onLongPress == null) {
      return;
    }
    setState(() {
      isPressed = false;
    });
  }

  void pressDown() {
    if (widget.onTap == null && widget.onLongPress == null) {
      return;
    }
    setState(() {
      isPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapCancel: pressUp,
      child: Listener(
        onPointerDown: (_) => pressDown(),
        onPointerUp: (_) => pressUp(),
        child: Container(
          color: Colors.transparent,
          child: AnimatedOpacity(
            duration: widget.duration,
            curve: Curves.easeOut,
            opacity: isPressed ? 0.6 : 1,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class DFGestureDetectorWithScaleInteraction extends StatefulWidget {
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Duration duration;
  final Widget child;

  const DFGestureDetectorWithScaleInteraction({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<DFGestureDetectorWithScaleInteraction> createState() =>
      _DFGestureDetectorWithScaleInteractionState();
}

class _DFGestureDetectorWithScaleInteractionState
    extends State<DFGestureDetectorWithScaleInteraction> {
  bool isPressed = false;

  void pressUp() {
    if (widget.onTap == null && widget.onLongPress == null) {
      return;
    }
    setState(() {
      isPressed = false;
    });
  }

  void pressDown() {
    if (widget.onTap == null && widget.onLongPress == null) {
      return;
    }
    setState(() {
      isPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.97 : 1,
      duration: widget.duration,
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onTapCancel: pressUp,
        child: Listener(
          onPointerDown: (_) => pressDown(),
          onPointerUp: (_) => pressUp(),
          child: widget.child,
        ),
      ),
    );
  }
}
