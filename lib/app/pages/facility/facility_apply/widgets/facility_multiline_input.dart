import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class FacilityMultilineInput extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;

  const FacilityMultilineInput({
    super.key,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      constraints: const BoxConstraints(minHeight: 240),
      padding: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing400,
        vertical: DFSpacing.spacing300,
      ),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        border: Border.all(color: colorTheme.lineOutline),
        borderRadius: BorderRadius.circular(DFRadius.radius400),
      ),
      child: TextField(
        controller: controller,
        minLines: 9,
        maxLines: 12,
        cursorColor: colorTheme.coreBrandPrimary,
        style: textTheme.body.copyWith(
          color: colorTheme.contentStandardPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: textTheme.body.copyWith(
            color: colorTheme.contentStandardTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
