import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:flutter/material.dart';

class DFNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double loadingHeight;
  final double borderRadius;
  final BoxFit fit;

  const DFNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.loadingHeight = 160,
    this.borderRadius = DFRadius.radius300,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<DFColors>()!;
    final typography = Theme.of(context).extension<DFTypography>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            child: frame == null
                ? DFShimmerLoadingBox(
                    width: width,
                    height: height ?? loadingHeight,
                    borderRadius: borderRadius,
                  )
                : child,
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height ?? loadingHeight,
          color: colors.backgroundStandardSecondary,
          alignment: Alignment.center,
          child: height != null
              ? Icon(
                  Icons.image_not_supported_outlined,
                  color: colors.contentStandardTertiary,
                )
              : Padding(
                  padding: const EdgeInsets.all(DFSpacing.spacing400),
                  child: Text(
                    '이미지를 불러오지 못했습니다.',
                    textAlign: TextAlign.center,
                    style: typography.paragraphSmall.copyWith(
                      color: colors.contentStandardTertiary,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
