import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFTextButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FacilityImagePickerField extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const FacilityImagePickerField({
    super.key,
    required this.images,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final imageText = images.length == 1
        ? images.first.name
        : '이미지 ${images.length}개 선택됨';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DFInputField(
          title: '이미지',
          inputs: [
            Row(
              children: [
                Expanded(
                  child: IgnorePointer(
                    child: DFInput(
                      content: images.isEmpty ? null : imageText,
                      placeholder: '이미지를 업로드 하세요.',
                    ),
                  ),
                ),
                const SizedBox(width: DFSpacing.spacing200),
                DFButton(
                  label: '파일찾기',
                  theme: DFButtonTheme.grayscale,
                  style: DFButtonStyle.secondary,
                  onPressed: onPick,
                ),
              ],
            ),
          ],
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: DFSpacing.spacing200),
          DFTextButton(
            label: '선택 취소',
            size: DFTextButtonSize.small,
            theme: DFTextButtonTheme.grayscale,
            onPressed: onClear,
          ),
        ],
      ],
    );
  }
}
