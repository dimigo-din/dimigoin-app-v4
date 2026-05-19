import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFControl.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';

class SchoolViolenceReportPage extends StatefulWidget {
  const SchoolViolenceReportPage({super.key});

  @override
  State<SchoolViolenceReportPage> createState() =>
      _SchoolViolenceReportPageState();
}

class _SchoolViolenceReportPageState extends State<SchoolViolenceReportPage> {
  final titleTEC = TextEditingController();
  final bodyTEC = TextEditingController();
  bool anonymous = true;

  @override
  void dispose() {
    titleTEC.dispose();
    bodyTEC.dispose();
    super.dispose();
  }

  void submitDummyReport() {
    if (titleTEC.text.trim().isEmpty || bodyTEC.text.trim().isEmpty) {
      DFSnackBar.error('제목과 신고 내용을 입력해주세요.');
      return;
    }

    DFSnackBar.info('학교폭력 신고 기능은 현재 준비 중입니다.');
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: const DFAppBar(title: '학폭 신고'),
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
                              placeholder: '신고 제목을 입력하세요',
                            ),
                          ],
                        ),
                        const SizedBox(height: DFSpacing.spacing500),
                        _DummyReportBody(controller: bodyTEC),
                        const SizedBox(height: DFSpacing.spacing500),
                        Row(
                          children: [
                            DFControl(
                              type: DFControlType.toggle,
                              status: anonymous,
                              onTap: () {
                                setState(() {
                                  anonymous = !anonymous;
                                });
                              },
                            ),
                            const SizedBox(width: DFSpacing.spacing200),
                            const Text('익명 신고'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: DFButton(
                    label: '신고 접수',
                    size: DFButtonSize.large,
                    onPressed: submitDummyReport,
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

class _DummyReportBody extends StatelessWidget {
  final TextEditingController controller;

  const _DummyReportBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
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
        minLines: 8,
        maxLines: 12,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '신고 내용을 입력하세요',
        ),
      ),
    );
  }
}
