import 'package:MetnaVadq/features/user/repository/api_auth_repository.dart';
import 'package:MetnaVadq/features/user/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // return a concrete implementation of AuthRepository
  return ApiAuthRepository();
});