import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/error_model.dart';
import '../models/refresh_token.dart';

final dioUnAuthClientProvider = Provider((ref) {
  Dio dioClient = Dio(
    BaseOptions(
      baseUrl: 'https://dio-task-manger-api.onrender.com/api/v1',
      connectTimeout: const Duration(seconds: 10000),
      receiveTimeout: const Duration(seconds: 10000),
      responseType: ResponseType.json,
    ),
  );
  return dioClient;
});

final dioAuthClientProvider = Provider((ref) {
  Dio dioClient = Dio(
    BaseOptions(
      baseUrl: 'https://dio-task-manger-api.onrender.com/api/v1',
      connectTimeout: const Duration(seconds: 10000),
      receiveTimeout: const Duration(seconds: 10000),
      responseType: ResponseType.json,
    ),
  );
  dioClient.options.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im5hbWUiOiJlbGxhIiwidXNlcklkIjoiNjViNDNkZDFhYTNiNDEwMTY2MTU1M2Y0In0sImlhdCI6MTcwNzgwODUzNiwiZXhwIjoxNzEwNDAwNTM2fQ.MPQvMnUnrFTyh36NoSj6PBvDxrLK8qsC9zMTiheSnJA";
  //dioClient.interceptors.add(TokenInterceptor(getRefreshToken()));
  return dioClient;
});

class TokenInterceptor extends Interceptor {
  late Dio _dio;
  //late String _accessToken;
  final Future<String> _refreshToken;
  TokenInterceptor(Future<String> refreshToken): _refreshToken = refreshToken;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if the token is expired or close to expiration
    if (isTokenExpired()) {
      // If the token is expired, refresh it (you'll have to implement this logic)
      Future<String> newToken = refreshToken(
          _refreshToken); // Implement your logic to refresh the token

      // Set the new token in the request header
      options.headers["Authorization"] = "Bearer $newToken";
    }
    // Continue with the request
    handler.next(options);
  }

  bool isTokenExpired() {
    DioException? error;
    var err = ErrorModel.fromJson(error!.response?.data);
    debugPrint("from Interceptor : $err");
    if (err.msg == 'Your token has expired!') {
      return true;
    }
    // Implement your logic to check if the token is expired or close to expiration
    // Return true if the token is expired, otherwise return false
    // You can check the token's expiration date or any other relevant condition.

    return false; // Placeholder, replace with your actual logic
  }

  Future<String> refreshToken(accessToken) async {
    // Implement your logic to refresh the token
    // Make the API call to refresh the token and get the new token
    // Return the new token
    Response response = await _dio.post(
      'https://dio-task-manger-api.onrender.com/api/v1/token/refresh-token',
      data: {
        'refresh_Token': _refreshToken,
      },
    );
    debugPrint("TOkens ${response.data}");
    // Update the access token

    var responseToken =  refreshTokenModelFromJson(response.data);
    setAccessToken(responseToken.tokens.accessToken);
    return accessToken = responseToken.tokens.accessToken;
    // return "new_token"; // Placeholder, replace with your actual logic
  }
}


Future<String> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("accessToken").toString() ;
  return token;
}

Future<String> getRefreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("refreshToken").toString();
  return token;
}

 setAccessToken(token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', token);
}

 setRefreshToken(token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('refreshToken', token);
}
