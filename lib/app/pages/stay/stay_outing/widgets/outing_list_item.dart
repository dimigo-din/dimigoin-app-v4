import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OutingListItem extends StatelessWidget {
  final Outing outing;
  final VoidCallback onTap;

  const OutingListItem({
    super.key,
    required this.outing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DFSpacing.spacing300),
      child: GestureDetector(
        onTap: onTap,
        child: DFValueList(
          type: DFValueListType.vertical,
          theme: DFValueListTheme.outlined,
          title: outing.reason ?? "",
          content: _formatTimeRange(),
          subTitle: _formatMealCancellation(),
        ),
      ),
    );
  }

  String _formatTimeRange() {
    if (outing.from == null || outing.to == null) return "";

    final from = DateTime.parse(outing.from!).toLocal();
    final to = DateTime.parse(outing.to!).toLocal();

    return "${DateFormat.Hm().format(from)} ~ ${DateFormat.Hm().format(to)}";
  }

  String _formatMealCancellation() {
    final breakfast = outing.breakfastCancel == true ? "X" : "O";
    final lunch = outing.lunchCancel == true ? "X" : "O";
    final dinner = outing.dinnerCancel == true ? "X" : "O";

    return "아침 $breakfast   점심 $lunch   저녁 $dinner";
  }
}
