import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/provider.dart';


final userAPIProvider = Provider((ref, ) {
   final userProvier = ref.watch(dioAuthClientProvider);
  return UserApi(authClient: userProvier);
});

abstract class IUserAPI {
  //FutureEitherVoid saveUserData(UserModel userModel);
  Future<dynamic> getUserData();
}

class UserApi implements IUserAPI {
  final Dio _authClient;

  UserApi({
    required Dio authClient,
  }) : _authClient = authClient;

  @override
  Future<dynamic> getUserData() async {
      try {
      var response = await _authClient.get(
        "www.nigeria,com",
      );
      // var data = response.data;
      // var userData = UserModel.fromJson(data);
      //return userData;
      return response;
    } on DioException {
      return null;
    } catch (e) {
      return null;
    }
  }
}
