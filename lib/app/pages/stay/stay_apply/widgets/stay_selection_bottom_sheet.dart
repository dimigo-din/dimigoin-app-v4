import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:flutter/material.dart';

class StaySelectionBottomSheet {
  static void show({
    required BuildContext context,
    required List<Stay> stayList,
    required int selectedStayIndex,
    required Function(Stay) onStaySelected,
  }) {
    DFAnimatedBottomSheet.show(
      context: context,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 24,
      ),
      children: [
        ...stayList.map((stay) {
          final isSelected = stayList.isNotEmpty &&
              selectedStayIndex < stayList.length &&
              stay == stayList[selectedStayIndex];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                onStaySelected(stay);
                Navigator.pop(context);
              },
              child: DFValueList(
                type: DFValueListType.horizontal,
                theme: isSelected
                    ? DFValueListTheme.active
                    : DFValueListTheme.outlined,
                title: stay.name,
                content: "(${stay.stayFrom} ~ ${stay.stayTo})",
              ),
            ),
          );
        }),
      ],
    );
  }
}
