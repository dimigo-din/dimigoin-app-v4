import 'package:dimigoin_app_v4/app/services/auth/model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserImageURL = 'user_image_url';
  static const _keyPersonalInformationName = 'name';
  static const _keyPersonalInformationNumber = 'number';
  static const _keyPersonalInformationGender = 'gender';
  static const _keyPersonalInformationId = 'user_id';

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
    await _storage.write(key: _keyPersonalInformationName, value: info.name);
    await _storage.write(key: _keyPersonalInformationNumber, value: info.number);
    await _storage.write(key: _keyPersonalInformationGender, value: info.gender);
  }

  static Future<void> saveUserImageURL(String imageUrl) async {
    await _storage.write(key: _keyUserImageURL, value: imageUrl);
  }

  static Future<String> getUserImageURL() async {
    return await _storage.read(key: _keyUserImageURL) ?? '';
  }

  static Future<void> saveUserId(String id) async {
    await _storage.write(key: _keyPersonalInformationId, value: id);
  }

  static Future<String> getUserId() async {
    return await _storage.read(key: _keyPersonalInformationId) ?? '';
  }

  static Future<PersonalInformation?> getPersonalInformation() async {
    final name = await _storage.read(key: _keyPersonalInformationName);
    final number = await _storage.read(key: _keyPersonalInformationNumber);
    final gender = await _storage.read(key: _keyPersonalInformationGender);
    final profileUrl = await _storage.read(key: _keyUserImageURL);
    final id = await _storage.read(key: _keyPersonalInformationId);

    if (name != null && number != null && gender != null && profileUrl != null && id != null) {
      return PersonalInformation(
        id: id,
        name: name,
        number: number,
        userGrade: int.parse(number.substring(0, 1)),
        userClass: int.parse(number.substring(1, 2)),
        userNumber: int.parse(number.substring(2, 4)),
        gender: gender,
        profileUrl: profileUrl,
      );
    }
    return null;
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
