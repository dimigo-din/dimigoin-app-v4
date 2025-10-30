import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';

class LaundryTimeSlotCard extends StatelessWidget {
  final LaundryTime time;
  final LaundryApply? application;
  final bool isMine;
  final VoidCallback onTap;

  const LaundryTimeSlotCard({
    super.key,
    required this.time,
    this.application,
    required this.isMine,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DFGestureDetectorWithScaleInteraction(
        onTap: () => {},
        child: DFGestureDetectorWithOpacityInteraction(
          onTap: onTap,
          child: DFValueList(
            type: DFValueListType.horizontal,
            theme: _getTheme(),
            title: time.time,
            content: application?.user?.name ?? "",
          ),
        ),
      ),
    );
  }

  DFValueListTheme _getTheme() {
    if (isMine) {
      return DFValueListTheme.active;
    } else if (application?.user != null) {
      return DFValueListTheme.disabled;
    } else {
      return DFValueListTheme.outlined;
    }
  }
}
