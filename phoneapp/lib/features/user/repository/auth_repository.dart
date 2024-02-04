import 'package:MetnaVadq/features/user/data/user_model.dart';

abstract class AuthRepository {
  // emits a new value every time the authentication state changes
  Stream<UserModel?> authStateChanges();

  Future<UserModel> signIn();

  Future<void> signOut();
}