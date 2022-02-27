import 'dart:convert';
import 'dart:io';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/server_details.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:http/http.dart' as http;

class PostService {
  static Future<List<Post>> getUsersPosts(String query,
      {bool isRecommended = false}) async {
    var uri = Uri.parse(serverUrl +
        '/posts' +
        (isRecommended ? '/recommended' : '') +
        '?$query');

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

      List<Post> list = responseBody['data']['posts']
          .map<Post>((data) => Post.fromJson(data))
          .toList();

      return list;
    } else {
      throw AppError(response.statusCode, response.body);
    }
  }

  static Future<void> uploadPost(Post post, File? imageFile) async {
    var uri = Uri.parse(serverUrl + '/posts');
    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var request = http.MultipartRequest("POST", uri);

    request.headers.addAll(requestHeaders);

    request.fields['title'] = post.title!;
    request.fields['description'] = post.description!;
    request.fields['isUserPublic'] = post.isUserPublic!.toString();
    if (post.tags!.isNotEmpty) {
      request.fields['tags'] = post.tags!.join(' ');
    }

    if (imageFile != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          await imageFile.readAsBytes(),
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      // TODO: Handle response
    } else {
      throw AppError(response.statusCode, 'Unable to upload post!');
    }
  }

  static Future<void> updatePost(Post post) async {
    var uri = Uri.parse(serverUrl + '/posts/${post.id}');

    var request = http.MultipartRequest("POST", uri);

    var requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${UserApi.instance.token}',
    };

    var requestBody = jsonEncode(post.toJson());

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

  static Future<void> deletePost(String postId) async {
    var uri = Uri.parse(serverUrl + '/posts/$postId');
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
