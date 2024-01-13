import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageController {
  static const storage = FlutterSecureStorage();

  static const String jwtStorageKey = 'jwt';
}