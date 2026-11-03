import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  Future<void> saveUserId(String uid) async {
    await _storage.write(
      key: 'user_id',
      value: uid,
    );
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> clearUserId() async {
    await _storage.delete(key: 'user_id');
  }
}