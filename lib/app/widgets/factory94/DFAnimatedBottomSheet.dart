import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class StaggeredAnimationItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Animation<double> animation;

  const StaggeredAnimationItem({
    Key? key,
    required this.child,
    required this.index,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const itemDuration = 400;
    const itemDelay = 100;
    const sheetDuration = 800;

    final startTime = (index * itemDelay) / sheetDuration;
    final endTime = startTime + (itemDuration / sheetDuration);

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        startTime.clamp(0.0, 1.0),
        endTime.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}

class DFAnimatedBottomSheet extends StatefulWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const DFAnimatedBottomSheet({
    Key? key,
    required this.children,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  State<DFAnimatedBottomSheet> createState() => _DFAnimatedBottomSheetState();

  static Future<T?> show<T>({
    required BuildContext context,
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    double? borderRadius,
  }) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: colorTheme.componentsFillStandardSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius ?? 20),
        ),
      ),
      builder: (context) => DFAnimatedBottomSheet(
        children: children,
        padding: padding,
        height: height,
      ),
    );
  }
}

class _DFAnimatedBottomSheetState extends State<DFAnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = _controller;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Container(
          height: widget.height,
          padding: const EdgeInsets.only(top: 24),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ...List.generate(
                    widget.children.length,
                    (index) => StaggeredAnimationItem(
                      index: index,
                      animation: _animation,
                      child: widget.children[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}