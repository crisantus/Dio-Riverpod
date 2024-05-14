import 'package:dio_riverpod/apis/user_api.dart';
import 'package:dio_riverpod/features/auth/views/login_view.dart';
import 'package:dio_riverpod/models/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../apis/auth_api.dart';
import '../../../core/util.dart';
import '../../../models/user_model.dart';
import '../../home/views/home_view.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userApi: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.user.id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentUserData();
});

/// this cannot be tested because it contains buildContext
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
        showSnackBar(
            context, 'Accounted created! Please login.${r.user.name}');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginView(),
        ));
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
        debugPrint(r.user.name);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
    );
  }

  Future<UserModel> getUserData(String uid) async {
    final userdata = await _userApi.getUserData(uid);
    return userdata;
  }

  Future<CurrentUser> getCurrentUserData() async {
    var res = await _userApi.currentUser();
    return res;
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
