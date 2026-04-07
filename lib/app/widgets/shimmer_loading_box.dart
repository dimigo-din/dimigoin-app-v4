import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DFShimmerLoadingBox extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const DFShimmerLoadingBox({
    super.key,
    this.child,
    this.height,
    this.width,
    this.borderRadius = 20,
    this.padding,
  }) : assert(
         child != null || height != null,
         'Either child or height must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final shimmerChild =
        child ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: colorTheme.componentsFillStandardPrimary,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: colorTheme.lineOutline, width: 1),
          ),
        );

    Widget shimmer = Shimmer.fromColors(
      baseColor: colorTheme.componentsFillStandardPrimary,
      highlightColor: colorTheme.componentsFillStandardTertiary,
      child: shimmerChild,
    );

    if (padding != null) {
      shimmer = Padding(padding: padding!, child: shimmer);
    }

    return shimmer;
  }
}
