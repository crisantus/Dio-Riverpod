import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioUnAuthClientProvider = Provider((ref) {
  Dio dioClient = Dio(
    BaseOptions(
      baseUrl: "base_url",
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
      baseUrl: "base_url",
      connectTimeout: const Duration(seconds: 10000),
      receiveTimeout: const Duration(seconds: 10000),
      responseType: ResponseType.json,
    ),
  );
   dioClient.interceptors.add(TokenInterceptor());
  return dioClient;
});

class TokenInterceptor extends Interceptor {
  late Dio _dio;
  late String _accessToken;
  late String _refreshToken;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if the token is expired or close to expiration
    if (isTokenExpired()) {
      // If the token is expired, refresh it (you'll have to implement this logic)
      Future<String> newToken =  refreshToken(_accessToken); // Implement your logic to refresh the token

      // Set the new token in the request header
      options.headers["Authorization"] = "Bearer $newToken";
    }
    // Continue with the request
    handler.next(options);
  }

  bool isTokenExpired() {
    DioException? error;
    if (error!.response?.statusCode == 401) {
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
        'YOUR_REFRESH_TOKEN_ENDPOINT',
        data: {
          'refresh_token': _refreshToken,
        },
      );

      // Update the access token
      return accessToken = response.data['access_token'];
   // return "new_token"; // Placeholder, replace with your actual logic
  }
}
