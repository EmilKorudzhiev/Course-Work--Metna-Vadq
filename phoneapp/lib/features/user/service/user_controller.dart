import 'package:MetnaVadq/features/user/data/user_model.dart';
import 'package:MetnaVadq/features/user/service/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userControllerProvider = Provider((ref) {

  throw UnimplementedError("userControllerProvider unimplemented!!!");

  // final userRepository = ref.read(userRepositoryProvider);
  // return UserController(userRepository: userRepository);
});

class UserController {
  final UserRepository _userepository;

  UserController({required UserRepository userRepository}): _userepository = userRepository;

  Future<UserModel> getUserProfile(int? id) async {
    final response = await _userepository.getUserProfile(id);

    throw UnimplementedError("UserController Unimplemented!!!");

    // UserModel userProfile = UserModel.fromJson(response);
    //
    // print(response);
    //
    // return userProfile;
  }

}
