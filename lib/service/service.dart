import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/logout_model.dart';
import '../model/signin_model.dart';
import '../utils/api_constant.dart';
import '../utils/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String? accessToken = prefs!.getString('accesstoken');
String? refreshToken = prefs!.getString('refreshtoken');

class Resource<T> {
  final String url;
  T Function(Response response) parse;
  Resource({required this.url, required this.parse});
}

class Webservice {
  static const storage = FlutterSecureStorage(); // Correct way to initialize


  // Login Service
  Future<LogInModel?> callLoginService(
      {required String email,
        required String password,
        required Function(SnackBar) showSnackBar}) async {
    final url = Uri.parse(ApiConstants.login);
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'email': email, 'password': password});
    try {
      final response = await http
          .post(
        url,
        headers: headers,
        body: body,
      )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        if (data['status'] == 'success') {
          return LogInModel.fromJson(data);
        }
      } else {
        showSnackBar(
          const SnackBar(
            content: Text('Login Failed Please check your credentials.'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      showSnackBar(
        const SnackBar(
          content: Text('An error occurred Please try again later.'),
        ),
      );
    }
    return null;
  }

  Future<LogOutModel?> callLogOutService(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authorization');

    if (token == null) {
      return null;
    }

    final url = Uri.parse(ApiConstants.logout);
    final body = {
      'token': token,
    };

    try {
      final response = await http
          .post(
        url,
        body: body,
      )
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print(response.statusCode);
      }

      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (data['success'] == true) {
          // Update condition to check 'success'
          return LogOutModel.fromJson(data);
        }
      }

      throw Exception('Logout Failed: Response code ${response.statusCode}');
    } catch (e) {
      throw Exception('Logout Failed: $e');
    }
  }
}
