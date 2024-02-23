
import 'package:MetnaVadq/core/api/dio/api.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Api _api;
  final SecureStorageManager _storage;

  UserRepository({required Api api, required SecureStorageManager storage}) : _api = api, _storage = storage;

  Future<Response> getUserProfile(int? id) async {
    throw UnimplementedError();
  }

}