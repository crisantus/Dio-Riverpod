import 'package:dio/dio.dart';
import 'package:dio_riverpod/core/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/failure.dart';
import '../core/types_def.dart';
import '../models/user_model.dart';


final authAPIProvider = Provider((ref) {
  final account = ref.watch(dioUnAuthClientProvider);
  return AuthAPI(
    unAuthClient: account,
  );
});

abstract class IAuthAPI {
  FutureEither<dynamic> signUp({
    required String email,
    required String password,
    required String username,
  });
  FutureEither<dynamic> login({
    required String email,
    required String password,
  });
  //Future<UserModel?> currentUserAccount();
  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final Dio _unAuthClient;

  AuthAPI({
    required Dio unAuthClient,
  }) : _unAuthClient = unAuthClient;

  @override
  FutureEither<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> body = {
        'password': password,
        'email': email,
      };
      final response = await _unAuthClient.post(
        "www.nigeria.com",
        data: body,
      );
      var data = response.data;
        var userData = UserModel.fromJson(data);
        debugPrint(userData.toString());
     
      return right(userData);
    } on DioException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<dynamic> signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      Map<String, dynamic> body = {
        'password': password,
        'username': username,
        'email': email
        //'token': await storage.read(key: 'fcmToken'),
        //'platform': await storage.read(key: 'DeviceName')
      };
      final response = await _unAuthClient.post(
        "www.nigeria.com",
        data: body,
      );
      
      return right(response);
    } on DioException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  // @override
  // Future<UserModel?> currentUserAccount() async {
  //   try {
  //     var response = await _authClient.get(
  //       "www.nigeria,com",
  //     );
  //     var data = response.data;
  //     var userData = UserModel.fromJson(data);
  //     return userData;
  //   } on DioException {
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  @override
  FutureEitherVoid logout() async {
    try {
      // await _authClient.close(
      //   sessionId: 'current',
      // );
      return right(null);
    } on DioException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
