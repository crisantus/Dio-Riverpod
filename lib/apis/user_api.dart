import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/failure.dart';
import '../core/provider.dart';
import '../core/types_def.dart';
import '../models/current_user.dart';
import '../models/error_model.dart';
import '../models/user_model.dart';

final userAPIProvider = Provider((
  ref,
) {
  final userProvier = ref.watch(dioAuthClientProvider);
  return UserApi(authClient: userProvier);
});

abstract class IUserAPI {
  //FutureEitherVoid saveUserData(UserModel userModel);
  Future<UserModel> getUserData(String uid);
  FutureEitherVoid updateUserData(UserModel userModel);
  // Stream<RealtimeMessage> getLatestUserProfileData();
  Future<CurrentUser> currentUser();
}

class UserApi implements IUserAPI {
  final Dio _authClient;

  UserApi({
    required Dio authClient,
  }) : _authClient = authClient;

  @override
  Future<UserModel> getUserData(String uid) async {
    try {
      var response = await _authClient.get('/users/$uid');
      debugPrint("data : $response");
      var data = response.data;
      var userData = UserModel.fromJson(data);
      return userData;
    } on DioException catch (e, stackTrace) {
      var err = e.response?.data;
      debugPrint("Dio Error: $err");
      var error = ErrorModel.fromJson(err);
      throw Failure(error.msg ?? 'Some unexpected error occurred', stackTrace);
    } catch (e, stackTrace) {
      throw Failure(e.toString(), stackTrace);
    }
  }

  @override
  FutureEitherVoid updateUserData(UserModel user) async {
    try {
      Map<String, dynamic> body = {
        'title': user.user.email,
        'description': user.user.name,
      };
      var response = await _authClient.patch(
        '/task/${user.user.id}',
        data: body,
      );
      debugPrint("data : $response");
      var data = response.data;
      var userData = UserModel.fromJson(data);
      debugPrint("Data: ${userData.user}");
      return right(null);
    } on DioException catch (e, stackTrace) {
      var err = e.response?.data;
      debugPrint("Dio Error: $err");
      var error = ErrorModel.fromJson(err);
      return left(
        Failure(error.msg ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  Future<CurrentUser> currentUser() async {
    try {
      var response = await _authClient.get('/users/showMe/');
      var user = CurrentUser.fromJson(response.data);
      return user;
    } on DioException catch (e, stackTrace) {
      var err = e.response?.data;
      debugPrint("Dio Error: $err");
      var error = ErrorModel.fromJson(err);
      return throw Failure(
          error.msg ?? 'Some unexpected error occurred', stackTrace);
    } catch (e, stackTrace) {
      return throw Failure(e.toString(), stackTrace);
    }
  }
}
