import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';

enum DFControlType { heart, star, toggle, check, checkfill, radio }

class DFControl extends StatelessWidget {
  final DFControlType type;
  final bool disabled;
  final bool status;
  final VoidCallback? onTap;

  const DFControl({
    super.key,
    required this.type,
    this.onTap,
    this.disabled = false,
    this.status = false,
  });

  Color getColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    if (status == false) {
      return colorTheme.contentStandardQuaternary;
    }

    switch (type) {
      case DFControlType.heart:
        return colorTheme.solidPink;
      case DFControlType.star:
        return colorTheme.solidYellow;
      case DFControlType.toggle ||
           DFControlType.check ||
           DFControlType.checkfill ||
           DFControlType.radio:
        return colorTheme.coreBrandPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: DFGestureDetectorWithOpacityInteraction(
        onTap: disabled ? null : type == DFControlType.toggle ? null : onTap,
        child: 
          switch (type) {
            DFControlType.heart => Icon(
              status ? Icons.favorite : Icons.favorite_border,
              color: getColor(context),
            ),
            DFControlType.star => Icon(
              status ? Icons.star : Icons.star_border,
              color: getColor(context),
            ),
            DFControlType.toggle => CupertinoSwitch(
              value: status,
              activeTrackColor: getColor(context),
              onChanged: disabled ? null : (value) => onTap?.call(),
            ),
            DFControlType.check => Transform.scale(
              scale: 1.2,
              child: Icon(
                Icons.check,
                color: getColor(context),
              ),
            ),
            DFControlType.checkfill => Transform.scale(
              scale: 1.2,
              child: Icon(
                status ? Icons.check_box :  Icons.check_box_outline_blank,
                color: getColor(context),
              ),
            ),
            DFControlType.radio => Icon(
              status ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: getColor(context),
            ),
          },
      ),
    );
  }
  
}