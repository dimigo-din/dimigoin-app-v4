import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedColumn.dart';
import 'package:flutter/material.dart';

class DFAnimatedBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const DFAnimatedBottomSheet({
    super.key,
    required this.children,
    this.height,
    this.padding,
  });

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
        padding: padding,
        height: height,
        children: children,
      ),
    );
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
          height: height,
          padding: const EdgeInsets.only(top: 24),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  padding ??
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
                  DFAnimatedColumn(children: children),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
