import 'dart:convert';

import 'package:failed_in/models/notification_model.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/server_details.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static getAllNotifications(String query) async {
    var uri = Uri.parse(serverUrl + '/users/notification?$query');

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

      List<AppNotification> list = responseBody['data']['notifications']
          .map<AppNotification>((data) => AppNotification.fromJson(data))
          .toList();

      return list;
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }
}
