import 'package:carousel_slider/carousel_slider.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/facility/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';

class FacilityDetailBottomSheet {
  static void show({
    required BuildContext context,
    required ReportFacility report,
    required Future<List<String>> imageFuture,
  }) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    DFAnimatedBottomSheet.show(
      context: context,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      children: [
        _label('제목', textTheme, colorTheme),
        const SizedBox(height: DFSpacing.spacing100),
        _value(report.subject, textTheme, colorTheme),
        const SizedBox(height: DFSpacing.spacing500),
        _label('내용', textTheme, colorTheme),
        const SizedBox(height: DFSpacing.spacing100),
        _value(report.body, textTheme, colorTheme),
        const SizedBox(height: DFSpacing.spacing500),
        _label('처리 상태', textTheme, colorTheme),
        const SizedBox(height: DFSpacing.spacing100),
        _value(_statusLabel(report.status), textTheme, colorTheme),
        const SizedBox(height: DFSpacing.spacing500),
        _label('이미지', textTheme, colorTheme),
        const SizedBox(height: DFSpacing.spacing100),
        _FacilityImages(imageFuture: imageFuture),
      ],
    );
  }

  static Widget _label(
    String text,
    DFTypography textTheme,
    DFColors colorTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: textTheme.callout.copyWith(
          color: colorTheme.contentStandardSecondary,
        ),
      ),
    );
  }

  static Widget _value(
    String text,
    DFTypography textTheme,
    DFColors colorTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: textTheme.body.copyWith(
          color: colorTheme.contentStandardPrimary,
        ),
      ),
    );
  }

  static String _statusLabel(String? status) {
    return switch (status) {
      'under_review' => '검토중',
      'working' => '처리중',
      'done' => '완료',
      'ignored' => '거절됨',
      'failed' => '수리실패',
      _ => '대기',
    };
  }
}

class _FacilityImages extends StatelessWidget {
  final Future<List<String>> imageFuture;

  const _FacilityImages({required this.imageFuture});

  static const double _imageHeight = 200;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    return FutureBuilder<List<String>>(
      future: imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const DFShimmerLoadingBox(
            height: _imageHeight,
            width: double.infinity,
            borderRadius: 8,
          );
        }

        if (snapshot.hasError) {
          return _imageFrame(
            colorTheme: colorTheme,
            child: Text(
              '신청 내역 이미지를 불러오는데 실패했습니다.',
              textAlign: TextAlign.center,
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardPrimary,
              ),
            ),
          );
        }

        final files = snapshot.data ?? const <String>[];
        if (files.isEmpty) {
          return _imageFrame(
            colorTheme: colorTheme,
            child: Text(
              '첨부된 이미지가 없습니다.',
              textAlign: TextAlign.center,
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardPrimary,
              ),
            ),
          );
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: _imageHeight,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
          ),
          items: files.map((fileUrl) {
            return Builder(
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: colorTheme.componentsFillStandardPrimary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorTheme.lineOutline),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      fileUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const DFShimmerLoadingBox(
                          height: _imageHeight,
                          width: double.infinity,
                          borderRadius: 8,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            '이미지를 불러오지 못했습니다.',
                            style: textTheme.body.copyWith(
                              color: colorTheme.contentStandardPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _imageFrame({required DFColors colorTheme, required Widget child}) {
    return Container(
      width: double.infinity,
      height: _imageHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(DFSpacing.spacing300),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorTheme.lineOutline),
      ),
      child: child,
    );
  }
}
