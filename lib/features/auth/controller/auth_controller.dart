import 'package:dio_riverpod/apis/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../apis/auth_api.dart';
import '../../../core/util.dart';
import '../../../models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userApi: ref.watch(userAPIProvider),
  );
});

final userDetailsProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserApi _userApi;

  AuthController({
    required AuthAPI authAPI,
    required UserApi userApi,
  })  : _authAPI = authAPI,
        _userApi = userApi,
        super(false);
  // state = isLoading

  //Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
      username: username,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        // UserModel userModel = UserModel(
        //   email: email,
        //   name: getNameFromEmail(email),
        //   followers: const [],
        //   following: const [],
        //   profilePic: '',
        //   bannerPic: '',
        //   uid: r.$id,
        //   bio: '',
        //   isTwitterBlue: false,
        // );
        //final res2 = await _userAPI.saveUserData(userModel);
        var data = r.data;
        var userData = UserModel.fromJson(data);

        showSnackBar(
            context, 'Accounted created! Please login.${userData.email}');
        // Navigator.push(context, LoginView.route());
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        debugPrint(r.toString());
        // Navigator.push(context, HomeView.route());
      },
    );
  }

  Future<UserModel> getUserData() async {
    final res = await _userApi.getUserData();
    final userdata = UserModel.fromMap(res.data);
    return userdata;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   SignUpView.route(),
      //   (route) => false,
      // );
    });
  }
}
