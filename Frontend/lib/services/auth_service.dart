import 'dart:convert';

import 'package:failed_in/models/user_model.dart';
import 'package:failed_in/services/storage_service.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/server_details.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<void> signupUser(User user) async {
    var url = Uri.parse(serverUrl + '/users/signup');

    var requestHeaders = {
      'Content-Type': 'application/json',
    };

    var requestBody = jsonEncode({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'password': user.password,
      'username': user.username,
    });

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: requestBody,
    );

    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('Success');
    } else {
      throw AppError(response.statusCode, responseBody['message']);
    }
  }

  static Future<void> loginUser(String email, String password) async {
    var url = Uri.parse(serverUrl + '/users/login');

    var requestHeaders = {
      'Content-Type': 'application/json',
    };

    var requestBody = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: requestBody,
    );

    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await StorageService.storeJWT(responseBody['token']);

      UserApi.setData(
        id: responseBody['data']['user']['_id'],
        email: responseBody['data']['user']['email'],
        firstName: responseBody['data']['user']['firstName'],
        lastName: responseBody['data']['user']['lastName'],
        username: responseBody['data']['user']['username'],
        image: responseBody['data']['user']['image'],
        bio: responseBody['data']['user']['bio'],
        token: responseBody['token'],
      );
    } else {
      throw AppError(response.statusCode, responseBody['message']);
    }
  }

  static Future<void> loadUserData(String token) async {
    var url = Uri.parse(serverUrl + '/users/me');

    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    var response = await http.get(
      url,
      headers: requestHeaders,
    );

    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      UserApi.setData(
        id: responseBody['data']['user']['_id'],
        email: responseBody['data']['user']['email'],
        firstName: responseBody['data']['user']['firstName'],
        lastName: responseBody['data']['user']['lastName'],
        username: responseBody['data']['user']['username'],
        image: responseBody['data']['user']['image'],
        bio: responseBody['data']['user']['bio'],
        token: token,
      );
    } else {
      throw AppError(response.statusCode, responseBody['message']);
    }
  }
}
