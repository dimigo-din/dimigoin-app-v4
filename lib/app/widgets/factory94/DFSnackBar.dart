import 'dart:async';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class DFSnackBar {
  static Completer<void>? _active;
  static Timer? _autoCloseTimer;
  static int _requestId = 0;

  static Future<void> open(
    String content, {
    Widget? leading,
    Duration duration = const Duration(seconds: 3),
  }) async {
    final currentId = ++_requestId;
    
    await _ensureOverlayReady();

    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;

    if (_active != null && !_active!.isCompleted) {
      _active!.complete();
    }

    if (Get.isSnackbarOpen) {
      try {
        Get.closeAllSnackbars();
      } catch (e) {
        // LateInitializationError 무시
      }
      await Future.delayed(const Duration(milliseconds: 350));
    }

    if (currentId != _requestId) {
      return;
    }

    final completer = Completer<void>();
    _active = completer;

    final context = Get.overlayContext ?? Get.context;
    if (context == null) {
      completer.complete();
      return;
    }

    final colorTheme = Theme.of(context).extension<DFColors>();
    final textTheme = Theme.of(context).extension<DFTypography>();

    final bg = colorTheme?.componentsFillStandardPrimary ?? Colors.white;
    final fg = colorTheme?.contentStandardPrimary ?? Colors.black87;
    final outline = colorTheme?.lineOutline ?? const Color(0x14000000);
    final body = textTheme?.body ?? const TextStyle(fontSize: 14, height: 1.35);

    Get.rawSnackbar(
      messageText: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DFSpacing.spacing550,
          vertical: DFSpacing.spacing300,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(DFRadius.radiusCircle),
          border: Border.all(color: outline, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(32, 33, 40, 0.06),
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: DFSpacing.spacing300),
            ],
            Flexible(
              child: Text(
                content,
                style: body.copyWith(color: fg, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.TOP,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing400,
        vertical: DFSpacing.spacing400,
      ),
      duration: duration,
      animationDuration: const Duration(milliseconds: 200),
      borderRadius: DFRadius.radiusCircle,
      boxShadows: const [],
    );

    _autoCloseTimer = Timer(duration + const Duration(milliseconds: 250), () {
      if (currentId == _requestId) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        _active = null;
        _autoCloseTimer = null;
      }
    });
  }

  static void success(String content, {Duration duration = const Duration(seconds: 3)}) {
    open(
      content,
      leading: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 20),
      duration: duration,
    );
  }

  static void error(String content, {Duration duration = const Duration(seconds: 3)}) {
    open(
      content,
      leading: const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 20),
      duration: duration,
    );
  }

  static void info(String content, {Duration duration = const Duration(seconds: 3)}) {
    open(
      content,
      leading: const Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 20),
      duration: duration,
    );
  }

  static void warning(String content, {Duration duration = const Duration(seconds: 3)}) {
    open(
      content,
      leading: const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 20),
      duration: duration,
    );
  }

  static Future<void> _ensureOverlayReady() async {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.transientCallbacks ||
        phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.postFrameCallbacks) {
      await WidgetsBinding.instance.endOfFrame;
    }
    await Future<void>.delayed(Duration.zero);
  }
}