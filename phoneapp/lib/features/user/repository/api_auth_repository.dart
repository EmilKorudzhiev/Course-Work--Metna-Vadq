import 'package:MetnaVadq/features/user/data/user_model.dart';
import 'package:MetnaVadq/features/user/repository/auth_repository.dart';

class ApiAuthRepository extends AuthRepository {
  @override
  Stream<UserModel?> authStateChanges() {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

}