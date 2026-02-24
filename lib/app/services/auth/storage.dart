import 'package:dimigoin_app_v4/app/services/auth/model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'dimigoin_db',
      publicKey: 'dimigoin_public_key',
    ),
  );

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserImageURL = 'user_image_url';
  static const _keyPersonalInformationName = 'name';
  static const _keyPersonalInformationGrade = 'grade';
  static const _keyPersonalInformationClass = 'class';
  static const _keyPersonalInformationGender = 'gender';
  static const _keyPersonalInformationId = 'user_id';
  static const _keyDeviceId = "device_id";

  /// Save both access and refresh tokens
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<void> savePersonalInformation(PersonalInformation info) async {
    await _storage.write(key: _keyPersonalInformationId, value: info.id);
    await _storage.write(key: _keyUserImageURL, value: info.profileUrl);
    await _storage.write(key: _keyPersonalInformationName, value: info.name);
    await _storage.write(key: _keyPersonalInformationGrade, value: info.userGrade.toString());
    await _storage.write(key: _keyPersonalInformationClass, value: info.userClass.toString());
    await _storage.write(key: _keyPersonalInformationGender, value: info.gender);
  }

  static Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }

  static Future<String?> getDeviceId() async {
    return await _storage.read(key: _keyDeviceId);
  }

  static Future<PersonalInformation?> getPersonalInformation() async {
    // Read all values at once to avoid timing issues on web (IndexedDB)
    final allValues = await _storage.readAll();

    final name = allValues[_keyPersonalInformationName];
    final grade = allValues[_keyPersonalInformationGrade];
    final classNumber = allValues[_keyPersonalInformationClass];
    final gender = allValues[_keyPersonalInformationGender];
    final profileUrl = allValues[_keyUserImageURL];
    final id = allValues[_keyPersonalInformationId];

    if (name != null && grade != null && classNumber != null && gender != null && profileUrl != null && id != null) {
      return PersonalInformation(
        id: id,
        name: name,
        userGrade: int.parse(grade),
        userClass: int.parse(classNumber),
        gender: gender,
        profileUrl: profileUrl,
      );
    }
    return null;
  }

  static Future<void> clearAuth() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserImageURL);
    await _storage.delete(key: _keyPersonalInformationName);
    await _storage.delete(key: _keyPersonalInformationGrade);
    await _storage.delete(key: _keyPersonalInformationClass);
    await _storage.delete(key: _keyPersonalInformationGender);
    await _storage.delete(key: _keyPersonalInformationId);
  }
}
