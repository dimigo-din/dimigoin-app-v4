import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DFShimmerLoadingBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const DFShimmerLoadingBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 20,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    Widget shimmer = Shimmer.fromColors(
      baseColor: colorTheme.componentsFillStandardPrimary,
      highlightColor: colorTheme.componentsFillStandardTertiary,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorTheme.componentsFillStandardPrimary,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: colorTheme.lineOutline, width: 1),
        ),
      ),
    );

    if (padding != null) {
      shimmer = Padding(padding: padding!, child: shimmer);
    }

    return shimmer;
  }
}