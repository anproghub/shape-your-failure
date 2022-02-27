import 'dart:convert';

import 'package:failed_in/models/reaction_model.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/server_details.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:http/http.dart' as http;

class ReactionService {
  static Future<void> reactToPost(Reaction reaction) async {
    var uri = Uri.parse(serverUrl + '/posts/${reaction.postId}/like');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var requestBody = jsonEncode(reaction.toJson());

    var response = await http.post(
      uri,
      headers: requestHeaders,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // TODO: Handle response

    } else {
      throw AppError(response.statusCode, response.body);
    }
  }

  static Future<List<Reaction>> getAllReactions(
      String postId, String query) async {
    var uri = Uri.parse(serverUrl + '/posts/$postId/like?$query');

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

      List<Reaction> list = responseBody['data']['likes']
          .map<Reaction>((data) => Reaction.fromJson(data))
          .toList();

      return list;
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }
}
