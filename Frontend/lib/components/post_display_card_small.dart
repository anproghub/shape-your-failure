import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/screens/single_post_screen.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';

class PostDisplayCardSmall extends StatelessWidget {
  const PostDisplayCardSmall({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SinglePostScreen(
              post: post,
            ),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: kColorPrimaryDark,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            image: post.image != null
                ? DecorationImage(
                    image: NetworkImage(
                      post.image!,
                      headers: {
                        'authorization': 'Bearer ${UserApi.instance.token!}',
                      },
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      kColorPrimaryDark.withOpacity(0.65),
                      BlendMode.srcATop,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  post.title!,
                  style: const TextStyle(
                    color: kColorLight,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
