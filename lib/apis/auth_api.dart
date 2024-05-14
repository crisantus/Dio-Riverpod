import 'package:dio/dio.dart';
import 'package:dio_riverpod/core/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/failure.dart';
import '../core/types_def.dart';
import '../models/error_model.dart';
import '../models/login_model.dart';
import '../models/signup_model.dart';


/// this can be tested
// this provider is use to provide for this class...
final authAPIProvider = Provider((ref) {
  final account = ref.watch(dioUnAuthClientProvider);
  return AuthAPI(
    unAuthClient: account,
  );
});

abstract class IAuthAPI {
  FutureEither<UserSignupModel> signUp({
    required String email,
    required String password,
    required String username,
  });
  FutureEither<LoginModel> login({
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
  FutureEither<LoginModel> login({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> body = {
        'password': password,
        'email': email,
      };
      final response = await _unAuthClient.post(
        "/auth/login",
        data: body,
      );
      debugPrint("data : $response");
      var data = response.data;
      var userData = LoginModel.fromJson(data);
      setAccessToken(userData.tokens.accessToken);
      setRefreshToken(userData.tokens.refreshToken);
      return right(userData);
    } on DioException catch (e, stackTrace) {
       var err = e.response?.data;
      debugPrint("Dio Error: $err");
        var error = ErrorModel.fromJson(err);
      return left(
        Failure(error.msg ?? 'Some unexpected error occurred', stackTrace),
      );
    }  catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<UserSignupModel> signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      Map<String, dynamic> body = {
        'password': password,
        'name': username,
        'email': email
       
      };
      final response = await _unAuthClient.post(
        "/auth/register",
        data: body,
      );
      debugPrint("data : $response");
        var userData = userSignupModelFromJson(response.data);
      return right(userData);
    } 
    on DioException catch (e, stackTrace) {
       var err = e.response?.data;
      debugPrint("Dio Error: $err");
        var error = ErrorModel.fromJson(err);
      return left(
        Failure(error.msg ?? 'Some unexpected error occurred', stackTrace),
      );
    } 
    catch (e, stackTrace) {
        debugPrint("Internal Error: $e");
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
  
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
