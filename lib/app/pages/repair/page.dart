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
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
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
  final locationTEC = TextEditingController();
  final bodyTEC = TextEditingController();
  final imagePicker = ImagePicker();

  List<XFile> images = [];
  List<FacilityReport> reports = [];
  bool isLoadingReports = true;
  bool isSubmitting = false;
  String? reportLoadError;

  @override
  void initState() {
    super.initState();
    repository = FacilityRepository(api: Get.find<ApiProvider>());
    loadReports();
  }

  @override
  void dispose() {
    titleTEC.dispose();
    locationTEC.dispose();
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
      reportLoadError = '수리 요청 내역을 불러오지 못했습니다.';
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
    final location = locationTEC.text.trim();
    final body = bodyTEC.text.trim();

    if (title.isEmpty || location.isEmpty || body.isEmpty) {
      DFSnackBar.error('제목, 위치, 상세 내용을 모두 입력해주세요.');
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
        location: location,
        body: body,
        files: files,
      );

      titleTEC.clear();
      locationTEC.clear();
      bodyTEC.clear();
      setState(() {
        images = [];
      });
      await loadReports();
      DFSnackBar.success('수리 요청이 접수되었습니다.');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorCode = e.response?.data is Map
          ? e.response?.data['code']?.toString()
          : null;
      final suffix = errorCode ?? statusCode?.toString();

      DFSnackBar.error(
        suffix == null ? '수리 요청 접수에 실패했습니다.' : '수리 요청 접수에 실패했습니다. ($suffix)',
      );
    } catch (_) {
      DFSnackBar.error('수리 요청 접수에 실패했습니다.');
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
          appBar: const DFAppBar(title: '수리 요청'),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DFSpacing.spacing400,
              vertical: DFSpacing.spacing500,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DFInputField(
                          title: '제목',
                          inputs: [
                            DFInput(
                              controller: titleTEC,
                              placeholder: '수리 요청 제목을 입력하세요',
                            ),
                          ],
                        ),
                        const SizedBox(height: DFSpacing.spacing500),
                        DFInputField(
                          title: '수리 요청 위치',
                          inputs: [
                            DFInput(
                              controller: locationTEC,
                              placeholder: '예: 본관 3층 복도',
                            ),
                          ],
                        ),
                        const SizedBox(height: DFSpacing.spacing500),
                        _MultilineInput(
                          title: '상세 내용',
                          controller: bodyTEC,
                          placeholder: '고장 상태와 필요한 조치를 입력하세요',
                        ),
                        const SizedBox(height: DFSpacing.spacing500),
                        _ImagePickerRow(
                          count: images.length,
                          onPick: pickImages,
                          onClear: () => setState(() => images = []),
                        ),
                        const SizedBox(height: DFSpacing.spacing700),
                        _ReportList(
                          reports: reports,
                          isLoading: isLoadingReports,
                          error: reportLoadError,
                          onRetry: loadReports,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: DFButton(
                    label: isSubmitting ? '접수 중...' : '수리 요청 접수',
                    size: DFButtonSize.large,
                    onPressed: isSubmitting ? null : submit,
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
        Padding(
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
        ),
        Container(
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
            minLines: 5,
            maxLines: 8,
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

class _ImagePickerRow extends StatelessWidget {
  final int count;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _ImagePickerRow({
    required this.count,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DFButton(
            label: count == 0 ? '사진 첨부' : '사진 $count장 첨부됨',
            theme: DFButtonTheme.grayscale,
            style: DFButtonStyle.secondary,
            leading: const Icon(Icons.photo_outlined),
            onPressed: onPick,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: DFSpacing.spacing200),
          DFButton(
            label: '삭제',
            theme: DFButtonTheme.negative,
            style: DFButtonStyle.secondary,
            onPressed: onClear,
          ),
        ],
      ],
    );
  }
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
      return Column(
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
      );
    }

    if (reports.isEmpty) {
      return Text(
        '접수된 수리 요청이 없습니다.',
        style: textTheme.body.copyWith(
          color: colorTheme.contentStandardSecondary,
        ),
      );
    }

    return Column(
      children: reports.take(5).map((report) {
        return Padding(
          padding: const EdgeInsets.only(bottom: DFSpacing.spacing200),
          child: DFItemList(
            title: report.subject,
            subTitle: report.status.isEmpty ? '접수됨' : report.status,
          ),
        );
      }).toList(),
    );
  }
}
