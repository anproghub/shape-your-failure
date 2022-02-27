import 'dart:convert';

import 'package:failed_in/models/user_model.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/server_details.dart';
import 'package:failed_in/utilities/user_api.dart';

import 'package:http/http.dart' as http;

class UserService {
  static Future<User> getUser(String userId) async {
    var uri = Uri.parse(serverUrl + '/users?_id=$userId');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var response = await http.get(
      uri,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      print(responseBody);

      return User.fromJson(responseBody['data']['users'][0]);
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }
}
