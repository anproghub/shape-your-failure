import 'package:failed_in/components/username_display.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/screens/single_post_screen.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';

class PostDisplayCard extends StatelessWidget {
  const PostDisplayCard({
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
            builder: (context) => SinglePostScreen(post: post),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
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
              color: kColorPrimaryDark,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: kColorGrey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UsernameDisplay(
                  userId: post.userId!,
                  username: post.username!,
                  userImage: post.userImage!,
                  color: kColorLight,
                  isAnonymous: !post.isUserPublic!,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      post.title!,
                      style: const TextStyle(
                        color: kColorLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    kSpace10Ver,
                    Text(
                      post.description!,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style: const TextStyle(
                        color: kColorLight,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
