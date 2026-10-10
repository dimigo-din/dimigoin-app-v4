import 'dart:math' as math;

import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/network_image.dart';
import 'package:flutter/material.dart';

class DFImageBottomSheet extends StatelessWidget {
  final String url;

  const DFImageBottomSheet({super.key, required this.url});

  static Future<void> show({
    required BuildContext context,
    required String url,
  }) async {
    if (url.isEmpty) return;
    await DFAnimatedBottomSheet.show<void>(
      context: context,
      padding: const EdgeInsets.only(
        left: DFSpacing.spacing500,
        right: DFSpacing.spacing500,
        bottom: DFSpacing.spacing550,
      ),
      children: [DFImageBottomSheet(url: url)],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const SizedBox.shrink();
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 520, maxHeight: maxHeight),
      child: LayoutBuilder(
        builder: (context, constraints) => DFNetworkImage(
          url: url,
          width: double.infinity,
          loadingHeight: math.min(constraints.maxWidth * 0.75, maxHeight),
          borderRadius: DFRadius.radius400,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
