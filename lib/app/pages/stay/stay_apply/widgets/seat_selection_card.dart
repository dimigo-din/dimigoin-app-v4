import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:flutter/material.dart';

class SeatSelectionCard extends StatelessWidget {
  final String selectedSeat;
  final VoidCallback onTap;

  const SeatSelectionCard({
    super.key,
    required this.selectedSeat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DFItemList(
      title: selectedSeat != '' ? selectedSeat : "좌석 미선택",
      subTitle: "내가 선택한 좌석",
      trailing: DFButton(
        onPressed: onTap,
        label: "좌석 선택하기",
        theme: DFButtonTheme.accent,
        style: DFButtonStyle.secondary,
      ),
    );
  }
}
