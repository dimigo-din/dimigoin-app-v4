import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFHeader.dart';
import 'package:flutter/material.dart';

class StayScheduleSelector extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const StayScheduleSelector({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: DFSpacing.spacing100),
        child: DFSectionHeader(
          title: title,
          size: DFSectionHeaderSize.large,
          rightIcon: Icons.keyboard_arrow_down,
          trailingText: "잔류 일정 선택",
        ),
      ),
    );
  }
}
