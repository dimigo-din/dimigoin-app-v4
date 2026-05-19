import 'package:dio/dio.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/provider/api_interface.dart';
import 'package:dimigoin_app_v4/app/services/facility/model.dart';
import 'package:dimigoin_app_v4/app/services/facility/repository.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

class RepairPage extends StatefulWidget {
  const RepairPage({super.key});

  @override
  State<RepairPage> createState() => _RepairPageState();
}

class _RepairPageState extends State<RepairPage> {
  late final FacilityRepository repository;
  final titleTEC = TextEditingController();
  final bodyTEC = TextEditingController();
  final imagePicker = ImagePicker();

  List<XFile> images = [];
  List<FacilityReport> reports = [];
  bool isLoadingReports = true;
  bool isSubmitting = false;
  String selectedReportType = 'broken';
  String? reportLoadError;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    repository = FacilityRepository(api: Get.find<ApiProvider>());
    loadReports();
  }

  @override
  void dispose() {
    titleTEC.dispose();
    bodyTEC.dispose();
    super.dispose();
  }

  Future<void> loadReports() async {
    setState(() {
      isLoadingReports = true;
      reportLoadError = null;
    });

    try {
      reports = await repository.getReports();
    } catch (_) {
      reportLoadError = '신청 목록을 불러오지 못했습니다.';
    } finally {
      if (mounted) {
        setState(() {
          isLoadingReports = false;
        });
      }
    }
  }

  Future<void> pickImages() async {
    final picked = await imagePicker.pickMultiImage();
    if (picked.isEmpty) return;

    setState(() {
      images = picked.take(5).toList();
    });
  }

  Future<void> submit() async {
    final title = titleTEC.text.trim();
    final body = bodyTEC.text.trim();

    if (title.isEmpty || body.isEmpty) {
      DFSnackBar.error('제목과 문의 내용을 모두 입력해주세요.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final files = <MultipartFile>[];
      for (final image in images) {
        files.add(
          MultipartFile.fromBytes(
            await image.readAsBytes(),
            filename: image.name,
          ),
        );
      }

      await repository.createRepairReport(
        subject: title,
        body: body,
        reportType: selectedReportType,
        files: files,
      );

      titleTEC.clear();
      bodyTEC.clear();
      setState(() {
        images = [];
        selectedReportType = 'broken';
        selectedTab = 1;
      });
      await loadReports();
      DFSnackBar.success('수리 신청이 접수되었습니다.');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorCode = e.response?.data is Map
          ? e.response?.data['code']?.toString()
          : null;
      final suffix = errorCode ?? statusCode?.toString();

      DFSnackBar.error(
        suffix == null ? '수리 신청에 실패했습니다.' : '수리 신청에 실패했습니다. ($suffix)',
      );
    } catch (_) {
      DFSnackBar.error('수리 신청에 실패했습니다.');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: const DFAppBar(title: '수리 신청'),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(
              DFSpacing.spacing400,
              DFSpacing.spacing300,
              DFSpacing.spacing400,
              DFSpacing.spacing500,
            ),
            child: Column(
              children: [
                DFSegmentControl(
                  key: ValueKey(selectedTab),
                  initialIndex: selectedTab,
                  segments: const [
                    DFSegment(label: '신청'),
                    DFSegment(label: '목록'),
                  ],
                  onChanged: (index) => setState(() {
                    selectedTab = index;
                  }),
                ),
                const SizedBox(height: DFSpacing.spacing500),
                Expanded(
                  child: selectedTab == 0
                      ? _RepairForm(
                          titleTEC: titleTEC,
                          bodyTEC: bodyTEC,
                          images: images,
                          selectedReportType: selectedReportType,
                          onPickImages: pickImages,
                          onClearImages: () => setState(() => images = []),
                          onReportTypeChanged: (value) => setState(() {
                            selectedReportType = value;
                          }),
                        )
                      : _ReportList(
                          reports: reports,
                          isLoading: isLoadingReports,
                          error: reportLoadError,
                          onRetry: loadReports,
                        ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: DFButton(
                    label: selectedTab == 0
                        ? (isSubmitting ? '신청 중...' : '신청하기')
                        : '신청하기',
                    size: DFButtonSize.large,
                    onPressed: isSubmitting
                        ? null
                        : selectedTab == 0
                        ? submit
                        : () => setState(() {
                            selectedTab = 0;
                          }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RepairForm extends StatelessWidget {
  final TextEditingController titleTEC;
  final TextEditingController bodyTEC;
  final List<XFile> images;
  final String selectedReportType;
  final VoidCallback onPickImages;
  final VoidCallback onClearImages;
  final ValueChanged<String> onReportTypeChanged;

  const _RepairForm({
    required this.titleTEC,
    required this.bodyTEC,
    required this.images,
    required this.selectedReportType,
    required this.onPickImages,
    required this.onClearImages,
    required this.onReportTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DFInputField(
            title: '제목',
            inputs: [
              DFInput(
                controller: titleTEC,
                placeholder: '예: 변기(우정학사 2층 2번째 칸)',
              ),
            ],
          ),
          const SizedBox(height: DFSpacing.spacing500),
          _ImagePickerField(
            images: images,
            onPick: onPickImages,
            onClear: onClearImages,
          ),
          const SizedBox(height: DFSpacing.spacing500),
          _MultilineInput(
            title: '문의 내용',
            controller: bodyTEC,
            placeholder: '수리 요청 내용을 입력하세요.',
          ),
          const SizedBox(height: DFSpacing.spacing500),
          _ReportTypePicker(
            selectedValue: selectedReportType,
            onChanged: onReportTypeChanged,
          ),
        ],
      ),
    );
  }
}

class _MultilineInput extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String placeholder;

  const _MultilineInput({
    required this.title,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(title: title),
        Container(
          constraints: const BoxConstraints(minHeight: 240),
          decoration: BoxDecoration(
            color: colorTheme.componentsFillStandardPrimary,
            border: Border.all(color: colorTheme.lineOutline),
            borderRadius: BorderRadius.circular(DFRadius.radius400),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DFSpacing.spacing400,
            vertical: DFSpacing.spacing300,
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
        ),
      ],
    );
  }
}

class _ImagePickerField extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _ImagePickerField({
    required this.images,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final imageText = images.isEmpty
        ? '이미지를 업로드 하세요.'
        : images.length == 1
        ? images.first.name
        : '이미지 ${images.length}개 선택됨';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(title: '이미지'),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: DFSpacing.spacing400,
                ),
                decoration: BoxDecoration(
                  color: colorTheme.componentsFillStandardPrimary,
                  border: Border.all(color: colorTheme.lineOutline),
                  borderRadius: BorderRadius.circular(DFRadius.radius400),
                ),
                child: Text(
                  imageText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.body.copyWith(
                    color: images.isEmpty
                        ? colorTheme.contentStandardTertiary
                        : colorTheme.contentStandardPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: DFSpacing.spacing200),
            SizedBox(
              width: 88,
              child: DFButton(
                label: '파일찾기',
                theme: DFButtonTheme.grayscale,
                style: DFButtonStyle.secondary,
                onPressed: onPick,
              ),
            ),
          ],
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: DFSpacing.spacing200),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onClear,
              child: Text(
                '선택 취소',
                style: textTheme.callout.copyWith(
                  color: colorTheme.contentStandardTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ReportTypePicker extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const _ReportTypePicker({
    required this.selectedValue,
    required this.onChanged,
  });

  static const options = [
    _RepairTypeOption(label: '제안', value: 'suggest'),
    _RepairTypeOption(label: '파손', value: 'broken'),
    _RepairTypeOption(label: '위험', value: 'danger'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(title: '처리 방안'),
        Row(
          children: [
            for (int index = 0; index < options.length; index++) ...[
              Expanded(
                child: _ReportTypeButton(
                  option: options[index],
                  selected: selectedValue == options[index].value,
                  onTap: () => onChanged(options[index].value),
                ),
              ),
              if (index != options.length - 1)
                const SizedBox(width: DFSpacing.spacing200),
            ],
          ],
        ),
      ],
    );
  }
}

class _ReportTypeButton extends StatelessWidget {
  final _RepairTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  const _ReportTypeButton({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorTheme.componentsFillStandardPrimary,
          border: Border.all(
            color: selected
                ? colorTheme.coreBrandPrimary
                : colorTheme.lineOutline,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(DFRadius.radius300),
        ),
        child: Text(
          option.label,
          style: textTheme.body.copyWith(
            color: selected
                ? colorTheme.coreBrandPrimary
                : colorTheme.contentStandardPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _RepairTypeOption {
  final String label;
  final String value;

  const _RepairTypeOption({required this.label, required this.value});
}

class _ReportList extends StatelessWidget {
  final List<FacilityReport> reports;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const _ReportList({
    required this.reports,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error!,
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardSecondary,
              ),
            ),
            const SizedBox(height: DFSpacing.spacing300),
            DFButton(
              label: '다시 불러오기',
              theme: DFButtonTheme.grayscale,
              style: DFButtonStyle.secondary,
              onPressed: onRetry,
            ),
          ],
        ),
      );
    }

    if (reports.isEmpty) {
      return Center(
        child: Text(
          '접수된 수리 신청이 없습니다.',
          style: textTheme.body.copyWith(
            color: colorTheme.contentStandardSecondary,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      color: colorTheme.coreBrandPrimary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: reports.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: DFSpacing.spacing300),
        itemBuilder: (context, index) {
          return _ReportListTile(report: reports[index]);
        },
      ),
    );
  }
}

class _ReportListTile extends StatelessWidget {
  final FacilityReport report;

  const _ReportListTile({required this.report});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final status = _RepairStatus.from(report.status);

    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing400,
        vertical: DFSpacing.spacing300,
      ),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius400),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              report.subject,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: DFSpacing.spacing300),
          Text(
            status.label,
            style: textTheme.body.copyWith(
              color: status.color(colorTheme),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepairStatus {
  final String label;
  final Color Function(DFColors colors) color;

  const _RepairStatus({required this.label, required this.color});

  factory _RepairStatus.from(String status) {
    return switch (status) {
      'under_review' => _RepairStatus(
        label: '검토중',
        color: (colors) => colors.contentStandardTertiary,
      ),
      'working' => _RepairStatus(
        label: '처리중',
        color: (colors) => colors.coreStatusPositive,
      ),
      'done' => _RepairStatus(
        label: '완료',
        color: (colors) => colors.coreStatusPositive,
      ),
      'ignored' => _RepairStatus(
        label: '무시됨',
        color: (colors) => colors.contentStandardTertiary,
      ),
      'failed' => _RepairStatus(
        label: '수리실패',
        color: (colors) => colors.coreStatusNegative,
      ),
      _ => _RepairStatus(
        label: '대기',
        color: (colors) => colors.contentStandardTertiary,
      ),
    };
  }
}

class _FieldLabel extends StatelessWidget {
  final String title;

  const _FieldLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: DFSpacing.spacing200,
        left: DFSpacing.spacing100,
        right: DFSpacing.spacing100,
      ),
      child: Text(
        title,
        style: textTheme.callout.copyWith(
          color: colorTheme.contentStandardSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
