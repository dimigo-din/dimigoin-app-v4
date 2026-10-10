import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/middleware/login.dart';
import '../../routes/pages.dart';
import '../../routes/routes.dart';
import '../auth/service.dart';

class PushNavigationService extends GetxService {
  String? _pendingUrl;
  bool _navigationReady = false;
  bool _scheduled = false;

  static Uri? _parseUrl(Object? value) {
    if (value is! String || value.trim().isEmpty) return null;

    try {
      Uri.decodeFull(value.trim());
      final uri = Uri.parse(value.trim());
      return uri.userInfo.isEmpty ? uri : null;
    } on FormatException {
      return null;
    } on ArgumentError {
      return null;
    }
  }

  static String? resolveRoute(Object? value) {
    final uri = _parseUrl(value);
    if (uri == null || uri.hasScheme || uri.hasAuthority || uri.hasFragment) {
      return null;
    }
    if (!AppPages.pages.any((page) => page.name == uri.path)) return null;
    if (uri.path == Routes.LOSTFOUND_DETAIL) {
      try {
        final ids = uri.queryParametersAll['id'];
        if (ids == null || ids.length != 1 || ids.single.trim().isEmpty) {
          return null;
        }
      } on FormatException {
        return null;
      }
    }
    return uri.toString();
  }

  static String? resolveUrl(Object? value) {
    final uri = _parseUrl(value);
    if (uri == null) return null;
    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty) {
      return uri.toString();
    }
    return resolveRoute(value);
  }

  bool handleUrl(Object? value) {
    final url = resolveUrl(value);
    if (url == null) return false;
    _pendingUrl = url;
    resumePendingNavigation();
    return true;
  }

  void markNavigationReady() {
    _navigationReady = true;
    resumePendingNavigation();
  }

  void resumePendingNavigation() {
    if (!_navigationReady || _pendingUrl == null || _scheduled || isClosed) {
      return;
    }
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (isClosed || Get.key.currentState == null) return;
      final route = _pendingUrl;
      if (route == null) return;
      final uri = Uri.parse(route);
      if (uri.hasScheme) {
        _pendingUrl = null;
        unawaited(_openWebUrl(uri));
        return;
      }

      final page = AppPages.pages.firstWhere((page) => page.name == uri.path);
      final requiresLogin =
          page.middlewares?.any(
            (middleware) => middleware is LoginMiddleware,
          ) ??
          false;
      final auth = Get.isRegistered<AuthService>()
          ? Get.find<AuthService>()
          : null;
      if (requiresLogin &&
          (auth == null ||
              !auth.isLoginSuccess ||
              !auth.isPersonalInfoRegistered)) {
        if (!{
          Routes.LOGIN,
          Routes.PW_LOGIN,
          Routes.SIGNUP,
        }.contains(Uri.parse(Get.currentRoute).path)) {
          Get.toNamed(route);
        }
        return;
      }

      _pendingUrl = null;
      if (Get.currentRoute != route) Get.toNamed(route);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> _openWebUrl(Uri uri) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) log('Could not open notification URL in browser');
    } catch (e) {
      log('Error opening notification URL in browser: $e');
    }
  }
}
