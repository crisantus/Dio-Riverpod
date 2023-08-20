import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RefreshTokenExample extends StatefulWidget {
  const RefreshTokenExample({super.key});

  @override
  RefreshTokenExampleState createState() => RefreshTokenExampleState();
}

class RefreshTokenExampleState extends State<RefreshTokenExample> {
  late Dio _dio;
  late String _accessToken;
  late String _refreshToken;

  @override
  void initState() {
    super.initState();

    _dio = Dio();
    _accessToken = 'YOUR_INITIAL_ACCESS_TOKEN';
    _refreshToken = 'YOUR_INITIAL_REFRESH_TOKEN';

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Set the Authorization header with the access token
          options.headers['Authorization'] = 'Bearer $_accessToken';
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (_isTokenExpiredError(error)) {
            // Token expired, refresh it
            await _refreshAccessToken();

            // Retry the failed request with the new access token
            RequestOptions? retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] = 'Bearer $_accessToken';
           
            
            //return _dio.request(retryOptions.path, options: retryOptions);
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _refreshAccessToken() async {
    try {
      // Make a request to your refresh token endpoint
      Response response = await _dio.post(
        'YOUR_REFRESH_TOKEN_ENDPOINT',
        data: {
          'refresh_token': _refreshToken,
        },
      );

      // Update the access token
      _accessToken = response.data['access_token'];

      // You may also need to update the refresh token if it changes
      // _refreshToken = response.data['refresh_token'];

      // Print the updated access token
      debugPrint('Access token refreshed: $_accessToken');
    } catch (error) {
      debugPrint('Error refreshing access token: $error');
    }
  }

  bool _isTokenExpiredError(DioException error) {
    // Implement your own logic to determine if the error corresponds to an expired token
    // For example, you might check the error.response.statusCode

    // Assume any 401 status code indicates an expired token
    return error.response?.statusCode == 401;
  }

  Future<void> _makeApiCall() async {
    try {
      // Make an API call using the Dio instance
      Response response = await _dio.get('YOUR_API_ENDPOINT');

      // Handle the API response as needed
      debugPrint('API response: ${response.data}');
    } catch (error) {
      debugPrint('API error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refresh Token Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _makeApiCall,
              child: const Text('Make API Call'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RefreshTokenExample(),
  ));
}
