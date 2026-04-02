import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String username, String password) async {
    debugPrint('🚀 API Request: Attempting login for user: $username');
    debugPrint('🔗 URL: https://dummyjson.com/auth/login');

    try {
      final response = await _dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      debugPrint('✅ API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final authBox = Hive.box('auth_box');
        await authBox.put('isLoggedIn', true);
        await authBox.put('userData', response.data);
      }

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Connection error occurred";
      debugPrint('❌ API Error: $errorMessage');
      throw errorMessage;
    }
  }

  Future<void> logout() async {
    final authBox = Hive.box('auth_box');
    await authBox.clear();
    debugPrint('🚪 User logged out and data cleared');
  }
}