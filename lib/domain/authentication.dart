import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_app/presentation/page/main_page/main_page.dart';

class Authentication {
  Future<http.Response> registerUser(
    String email,
    String password,
    String confirmPassword,
    String username,
  ) async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/auth/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'username': username,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      // Registration successful
      return response;
    } else {
      // Handle error
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/auth/login');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> login(
      {required GlobalKey<FormState> formKey,
      required TextEditingController usernameController,
      required TextEditingController passwordController,
      required BuildContext context,
      required Function(String) setErrorMessage}) async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Loading');
      try {
        final response = await loginUser(
          usernameController.text,
          passwordController.text,
        );
        // Handle login response
        // ignore: use_build_context_synchronously
        await handleLoginResponse(response, context);
      } catch (e) {
        // Handle login error
        setErrorMessage(e.toString().replaceFirst('Exception: ', ''));
      }
      EasyLoading.dismiss();
    }
  }

  Future<void> handleLoginResponse(
      Map<String, dynamic> response, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', response['accessToken']);
    prefs.setString('refreshToken', response['refreshToken']);
    // Optionally, simpan yang lain
    prefs.setString('username', response['username']);
    prefs.setString('email', response['email']);
    // Save the access token expiration time
    int accessTokenExpiration =
        DateTime.now().millisecondsSinceEpoch + (2 * 60 * 1000); // 2 minutes
    prefs.setInt('accessTokenExpiration', accessTokenExpiration);
    // Navigate to the home screen
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainPage(
          username: response['username'],
          email: response['email'],
        ),
      ),
    );
  }

  Future<void> logoutUser() async {
    String? accessToken = await getAccessToken();
    if (accessToken != null) {
      final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/auth/logout');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await http.post(url, headers: headers);

      if (response.statusCode != 200) {
        throw Exception('Failed to log out');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('accessTokenExpiration');
      await prefs.remove('username');
      await prefs.remove('email');
    } else {
      throw Exception('No access token found');
    }
  }

  Future<void> updateUserProfile(String email, String username) async {
    String? accessToken = await getAccessToken();
    if (accessToken != null) {
      final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/users/me');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = jsonEncode({
        'username': username,
        'email': email,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } else {
      throw Exception('No access token found');
    }
  }

  Future<void> updateUserPassword(
    String currentPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    String? accessToken = await getAccessToken();
    if (accessToken != null) {
      final url =
          Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/users/me/password');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } else {
      throw Exception('No access token found');
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    int? expirationTime = prefs.getInt('accessTokenExpiration');

    if (accessToken != null && expirationTime != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime >= expirationTime) {
        accessToken = await refreshToken();
      }
    } else {
      accessToken = await refreshToken();
    }
    return accessToken;
  }

  Future<String> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      final url = Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/auth/token');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'token': refreshToken});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final newTokens = jsonDecode(response.body);
        await prefs.setString('accessToken', newTokens['accessToken']);
        // Assume the new access token is valid for another 2 minutes
        int accessTokenExpiration =
            DateTime.now().millisecondsSinceEpoch + (2 * 60 * 1000);
        await prefs.setInt('accessTokenExpiration', accessTokenExpiration);
        return newTokens['accessToken'];
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      throw Exception('No refresh token found');
    }
  }
}
