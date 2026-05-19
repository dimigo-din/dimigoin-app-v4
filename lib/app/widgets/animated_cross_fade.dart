import 'package:flutter/material.dart';

typedef CrossFadeChild = Widget Function(BuildContext context);

class DFAnimatedCrossFade extends StatelessWidget {
  const DFAnimatedCrossFade({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.crossFadeState,
    required this.duration,
    this.reverseDuration,
    this.firstCurve = Curves.linear,
    this.secondCurve = Curves.linear,
    this.sizeCurve = Curves.linear,
    this.alignment = Alignment.topCenter,
    this.layout,
    this.animateSize = true,
  });

  final CrossFadeChild firstChild;
  final CrossFadeChild secondChild;
  final CrossFadeState crossFadeState;

  final Duration duration;
  final Duration? reverseDuration;

  final Curve firstCurve;
  final Curve secondCurve;
  final Curve sizeCurve;

  final AlignmentGeometry alignment;
  final AnimatedSwitcherLayoutBuilder? layout;
  final bool animateSize;

  static Widget _defaultLayout(
    Widget? currentChild,
    List<Widget> previousChildren,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showFirst = crossFadeState == CrossFadeState.showFirst;
    final Widget targetChild = showFirst
        ? firstChild(context)
        : secondChild(context);

    final switcher = AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      layoutBuilder: layout ?? _defaultLayout,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final bool isFirstChild =
            (child.key as ValueKey<CrossFadeState>?)?.value ==
            CrossFadeState.showFirst;
        final Curve curve = isFirstChild ? firstCurve : secondCurve;
        final Animation<double> opacity = animation.drive(
          CurveTween(curve: curve),
        );
        return FadeTransition(opacity: opacity, child: child);
      },
      child: KeyedSubtree(
        key: ValueKey<CrossFadeState>(crossFadeState),
        child: targetChild,
      ),
    );

    return ClipRect(
      child: animateSize
          ? AnimatedSize(
              alignment: alignment,
              duration: duration,
              reverseDuration: reverseDuration,
              curve: sizeCurve,
              child: switcher,
            )
          : switcher,
    );
  }
}
