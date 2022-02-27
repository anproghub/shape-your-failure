import 'dart:convert';
import 'package:failed_in/models/report_comment_model.dart';
import 'package:failed_in/models/report_post_model.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/server_details.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:http/http.dart' as http;

class ReportService {
  static Future<void> reportToPost(ReportPost report) async {
    var uri = Uri.parse(serverUrl + '/posts/${report.postId}/report');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var requestBody = jsonEncode(report.toJson());

    var response = await http.post(
      uri,
      headers: requestHeaders,
      body: requestBody,
    );

    print(response.body);

    if (response.statusCode == 200) {
      // TODO: Handle response
      print('Reported');
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }

  static Future<void> reportToComment(ReportComment report) async {
    var uri = Uri.parse(serverUrl +
        '/posts/${report.postId}/comment/${report.commentId}/report');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var requestBody = jsonEncode(report.toJson());

    var response = await http.post(
      uri,
      headers: requestHeaders,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // TODO: Handle response
      print('Reported');
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }
}
