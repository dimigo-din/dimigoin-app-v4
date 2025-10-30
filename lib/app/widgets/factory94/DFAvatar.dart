import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:flutter_svg/svg.dart';

enum DFAvatarSize { small, medium, large }
enum DFAvatarType { classroom, person }
enum DFAvatarFill { icon, image }

class DFAvatar extends StatelessWidget {
  final DFAvatarSize size;
  final DFAvatarType type;
  final DFAvatarFill fill;
  final Widget? image;

  const DFAvatar({
    super.key,
    this.size = DFAvatarSize.large,
    this.type = DFAvatarType.person,
    this.fill = DFAvatarFill.icon,
    this.image,
  });

  double get iconSize {
    switch (size) {
      case DFAvatarSize.small:
        return 20;
      case DFAvatarSize.medium:
        return 40;
      case DFAvatarSize.large:
        return 60;
    }
  }

  double get widgetSize {
    switch (size) {
      case DFAvatarSize.small:
        return 24;
      case DFAvatarSize.medium:
        return 48;
      case DFAvatarSize.large:
        return 72;
    }
  }

  double get radius {
    switch (type) {
      case DFAvatarType.person:
        return DFRadius.radiusCircle;
      case DFAvatarType.classroom:
        return DFRadius.radius600;
    }
  }

  Color? getBackgroundColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    switch (fill) {
      case DFAvatarFill.icon:
        return colorTheme.componentsFillStandardSecondary;
      case DFAvatarFill.image:
        return colorTheme.componentsFillStandardSecondary;
    }
  }

  Widget buildIcon(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    final l = type == DFAvatarType.person
        ? SvgPicture.asset('assets/icons/avatar_person.svg', width: iconSize, height: iconSize, fit: BoxFit.contain, colorFilter: ColorFilter.mode(colorTheme.contentStandardPrimary, BlendMode.srcIn))
        : SvgPicture.asset('assets/icons/avatar_classroom.svg', width: iconSize, height: iconSize, fit: BoxFit.contain, colorFilter: ColorFilter.mode(colorTheme.contentStandardPrimary, BlendMode.srcIn));

    if (l is Icon) {
      return l;
    } else {
      return l;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      width: widgetSize,
      height: widgetSize,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: getBackgroundColor(context),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorTheme.lineOutline,
          width: 1,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: iconSize,
            maxHeight: iconSize,
          ),
          child: fill == DFAvatarFill.icon
              ? buildIcon(context)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: image,
                  ),
                ),
        ),
      ),
    );
  }
}