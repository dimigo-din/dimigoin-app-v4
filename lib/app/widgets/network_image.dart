import 'dart:async';
import 'dart:ui' as ui;

import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DFNetworkImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final double loadingHeight;
  final double borderRadius;
  final BoxFit fit;

  const DFNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.loadingHeight = 160,
    this.borderRadius = DFRadius.radius300,
    this.fit = BoxFit.cover,
  });

  @visibleForTesting
  static Future<Uint8List> Function(String url)? debugLoadBytes;

  /// Clears downloaded image data. In-progress downloads are allowed to finish.
  static void clearMemoryCache() => _ImageByteCache.clear();

  @override
  State<DFNetworkImage> createState() => _DFNetworkImageState();
}

class _DFNetworkImageState extends State<DFNetworkImage>
    with AutomaticKeepAliveClientMixin {
  bool _useWebFallback = false;

  @override
  bool get wantKeepAlive => _useWebFallback;

  @override
  void didUpdateWidget(covariant DFNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _useWebFallback = false;
      updateKeepAlive();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _image(
      _useWebFallback
          ? NetworkImage(
              widget.url,
              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
            )
          : _CachedImageProvider(widget.url),
    );
  }

  Widget _loading() => DFShimmerLoadingBox(
    width: widget.width,
    height: widget.height ?? widget.loadingHeight,
    borderRadius: widget.borderRadius,
  );

  Widget _image(ImageProvider provider) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final width = widget.width;
    final height = widget.height;
    // Keep thumbnail decoding small, preserving the original aspect ratio.
    // The downloaded bytes remain shared with detail and full-image views.
    if (provider is _CachedImageProvider &&
        width != null &&
        height != null &&
        width.isFinite &&
        height.isFinite &&
        width > 0 &&
        height > 0) {
      provider = ResizeImage(
        provider,
        width: (width * pixelRatio).ceil(),
        height: (height * pixelRatio).ceil(),
        policy: ResizeImagePolicy.fit,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Image(
        image: provider,
        width: width,
        height: height,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            child: frame == null ? _loading() : child,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (kIsWeb &&
              error is DioException &&
              error.type == DioExceptionType.connectionError) {
            final url = widget.url;
            // HTML images can display cross-origin photos even when fetching
            // their bytes is blocked. Retain them while scrolling this list.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && widget.url == url && !_useWebFallback) {
                setState(() => _useWebFallback = true);
                updateKeepAlive();
              }
            });
            return _image(
              NetworkImage(
                url,
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
              ),
            );
          }
          return _error(context);
        },
      ),
    );
  }

  Widget _error(BuildContext context) {
    final colors = Theme.of(context).extension<DFColors>()!;
    final typography = Theme.of(context).extension<DFTypography>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: widget.width,
        height: widget.height ?? widget.loadingHeight,
        color: colors.backgroundStandardSecondary,
        alignment: Alignment.center,
        child: widget.height != null
            ? Padding(
                padding: const EdgeInsets.all(DFSpacing.spacing100),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '로딩 실패',
                    textAlign: TextAlign.center,
                    style: typography.footnote.copyWith(
                      color: colors.contentStandardTertiary,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(DFSpacing.spacing400),
                child: Text(
                  '이미지를 불러오지 못했습니다.',
                  textAlign: TextAlign.center,
                  style: typography.paragraphSmall.copyWith(
                    color: colors.contentStandardTertiary,
                  ),
                ),
              ),
      ),
    );
  }
}

class _CachedImageProvider extends ImageProvider<_CachedImageProvider> {
  final String url;
  const _CachedImageProvider(this.url);

  @override
  Future<_CachedImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    _CachedImageProvider key,
    ImageDecoderCallback decode,
  ) => MultiFrameImageStreamCompleter(codec: _decode(decode), scale: 1);

  Future<ui.Codec> _decode(ImageDecoderCallback decode) async {
    try {
      final bytes = await _ImageByteCache.load(url);
      return await decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    } catch (_) {
      _ImageByteCache.evict(url);
      scheduleMicrotask(() => PaintingBinding.instance.imageCache.evict(this));
      rethrow;
    }
  }

  // ImageCache keys contain the URL, not the downloaded bytes, so that its
  // thumbnail cache cannot retain full-size files beyond the byte-cache limit.
  @override
  bool operator ==(Object other) =>
      other is _CachedImageProvider && other.url == url;

  @override
  int get hashCode => url.hashCode;
}

class _ImageByteCache {
  static const _maximumBytes = 32 * 1024 * 1024;
  static const _maximumEntries = 128;
  static final _entries = <String, Uint8List>{};
  static final _pending = <String, Future<Uint8List>>{};
  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.bytes,
    ),
  );
  static int _size = 0;

  static Uint8List? peek(String url) {
    final bytes = _entries.remove(url);
    if (bytes != null) _entries[url] = bytes;
    return bytes;
  }

  static Future<Uint8List> load(String url) {
    final cached = peek(url);
    if (cached != null) return SynchronousFuture(cached);
    return _pending.putIfAbsent(
      url,
      () => _download(url)
          .then((bytes) {
            if (bytes.isEmpty) throw StateError('Image data is empty.');
            if (bytes.lengthInBytes <= _maximumBytes) {
              while (_entries.isNotEmpty &&
                  (_size + bytes.lengthInBytes > _maximumBytes ||
                      _entries.length >= _maximumEntries)) {
                evict(_entries.keys.first);
              }
              _entries[url] = bytes;
              _size += bytes.lengthInBytes;
            }
            return bytes;
          })
          .whenComplete(() {
            _pending.remove(url);
          }),
    );
  }

  static Future<Uint8List> _download(String url) async {
    final loader = DFNetworkImage.debugLoadBytes;
    if (loader != null) return loader(url);
    final response = await _dio.get<List<int>>(url);
    final data = response.data;
    if (data == null) throw StateError('Image data is empty.');
    return data is Uint8List ? data : Uint8List.fromList(data);
  }

  static void evict(String url) {
    final bytes = _entries.remove(url);
    if (bytes != null) _size -= bytes.lengthInBytes;
  }

  static void clear() {
    _entries.clear();
    _size = 0;
  }
}
