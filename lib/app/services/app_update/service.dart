import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateInfo {
  final String latestVersion;
  final Uri storeUri;

  const AppUpdateInfo({required this.latestVersion, required this.storeUri});
}

class AppUpdateService extends GetxService {
  static const String _iosAppStoreId = '6756642944';

  final Dio _dio;
  bool _isChecking = false;
  bool _isDialogOpen = false;

  AppUpdateService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          );

  Future<void> checkForUpdate() async {
    if (kIsWeb || _isChecking || _isDialogOpen) {
      return;
    }

    _isChecking = true;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final updateInfo = await _fetchLatestVersion(packageInfo);

      if (updateInfo == null) {
        return;
      }

      if (_isStoreVersionNewer(updateInfo.latestVersion, packageInfo.version)) {
        _showRequiredUpdateDialog(updateInfo);
      }
    } catch (e) {
      debugPrint('App update check failed: $e');
    } finally {
      _isChecking = false;
    }
  }

  Future<AppUpdateInfo?> _fetchLatestVersion(PackageInfo packageInfo) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _fetchIosVersion(packageInfo.packageName);
    }
    if (Platform.isAndroid) {
      return _fetchAndroidVersion(packageInfo.packageName);
    }
    return Future.value(null);
  }

  Future<AppUpdateInfo?> _fetchIosVersion(String bundleId) async {
    final lookupUri = Uri.https('itunes.apple.com', '/lookup', {
      'bundleId': bundleId,
      'country': 'kr',
    });

    final response = await _dio.getUri(lookupUri);
    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? const [];

    Map<String, dynamic>? app;
    for (final result in results) {
      if (result is Map<String, dynamic> && result['bundleId'] == bundleId) {
        app = result;
        break;
      }
    }
    if (app == null) {
      for (final result in results) {
        if (result is Map<String, dynamic>) {
          app = result;
          break;
        }
      }
    }

    final version = app?['version']?.toString();
    final storeUrl = app?['trackViewUrl']?.toString();
    if (version == null || version.isEmpty) {
      return null;
    }

    return AppUpdateInfo(
      latestVersion: version,
      storeUri: Uri.parse(
        storeUrl ?? 'https://apps.apple.com/kr/app/id$_iosAppStoreId',
      ),
    );
  }

  Future<AppUpdateInfo?> _fetchAndroidVersion(String packageName) async {
    final storeUri = Uri.https('play.google.com', '/store/apps/details', {
      'id': packageName,
      'hl': 'ko',
      'gl': 'KR',
    });

    final response = await _dio.getUri<String>(storeUri);
    final html = response.data;
    if (html == null || html.isEmpty) {
      return null;
    }

    final version = _parsePlayStoreVersion(html);
    if (version == null || version.isEmpty) {
      return null;
    }

    return AppUpdateInfo(latestVersion: version, storeUri: storeUri);
  }

  String? _parsePlayStoreVersion(String html) {
    final versionMatches = RegExp(
      r'\[\[\["([0-9]+(?:\.[0-9]+){1,3})"\]\]',
    ).allMatches(html).map((match) => match.group(1)).whereType<String>();

    for (final version in versionMatches) {
      if (!version.startsWith('0.')) {
        return version;
      }
    }

    return RegExp(
      r'"softwareVersion"\s*:\s*"([^"]+)"',
    ).firstMatch(html)?.group(1);
  }

  bool _isStoreVersionNewer(String storeVersion, String currentVersion) {
    final storeParts = _versionParts(storeVersion);
    final currentParts = _versionParts(currentVersion);
    final length = storeParts.length > currentParts.length
        ? storeParts.length
        : currentParts.length;

    for (var i = 0; i < length; i++) {
      final store = i < storeParts.length ? storeParts[i] : 0;
      final current = i < currentParts.length ? currentParts[i] : 0;

      if (store > current) {
        return true;
      }
      if (store < current) {
        return false;
      }
    }

    return false;
  }

  List<int> _versionParts(String version) {
    return version
        .split(RegExp(r'[.+-]'))
        .map((part) => int.tryParse(part) ?? 0)
        .toList();
  }

  void _showRequiredUpdateDialog(AppUpdateInfo updateInfo) {
    if (Get.context == null || _isDialogOpen) {
      return;
    }

    _isDialogOpen = true;
    Get.dialog<void>(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('업데이트가 필요합니다'),
          content: Text(
            '디미고인 최신 버전 ${updateInfo.latestVersion}이 출시되었습니다. '
            '스토어에서 업데이트한 뒤 앱을 사용해주세요.',
          ),
          actions: [
            TextButton(
              onPressed: () => _openStore(updateInfo.storeUri),
              child: const Text('업데이트'),
            ),
            TextButton(
              onPressed: () {
                _isDialogOpen = false;
                Get.back<void>();
                unawaited(checkForUpdate());
              },
              child: const Text('다시 확인'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    ).whenComplete(() => _isDialogOpen = false);
  }

  Future<void> _openStore(Uri storeUri) async {
    if (Platform.isAndroid) {
      final packageName = storeUri.queryParameters['id'];
      if (packageName != null && packageName.isNotEmpty) {
        final marketUri = Uri.parse('market://details?id=$packageName');
        if (await canLaunchUrl(marketUri)) {
          await launchUrl(marketUri, mode: LaunchMode.externalApplication);
          return;
        }
      }
    }

    await launchUrl(storeUri, mode: LaunchMode.externalApplication);
  }
}
