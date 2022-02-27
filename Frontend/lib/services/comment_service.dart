import 'dart:convert';

import 'package:failed_in/models/comment_model.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/server_details.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static Future<List<Comment>> loadCommentsInPost(
      String postId, String query) async {
    var uri = Uri.parse(serverUrl + '/posts/$postId/comment?$query');

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

      List<Comment> list = responseBody['data']['comments']
          .map<Comment>((data) => Comment.fromJson(data))
          .toList();

      return list;
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }

  static Future<List<Comment>> loadRepliesInComment(
      String postId, String parentId, String query) async {
    var uri = Uri.parse(
        serverUrl + '/posts/$postId/comment?parentId=$parentId&$query');
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

      List<Comment> list = responseBody['data']['comments']
          .map<Comment>((data) => Comment.fromJson(data))
          .toList();

      return list;
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }

  static Future<void> postComment(Comment comment) async {
    var uri = Uri.parse(serverUrl + '/posts/${comment.postId}/comment');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var requestBody = jsonEncode(comment.toJson());

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

  static Future<void> updateComment(Comment comment) async {
    var uri =
        Uri.parse(serverUrl + '/posts/${comment.postId}/comment/${comment.id}');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var requestBody = jsonEncode(comment.toJson());

    var response = await http.put(
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

  static Future<void> deleteComment(Comment comment) async {
    var uri =
        Uri.parse(serverUrl + '/posts/${comment.postId}/comment/${comment.id}');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };
    var response = await http.delete(
      uri,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      // TODO: Handle response
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }
}
