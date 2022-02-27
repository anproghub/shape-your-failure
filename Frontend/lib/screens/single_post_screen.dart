import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/post_card.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

class SinglePostScreen extends StatefulWidget {
  const SinglePostScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;
  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  bool isDescriptionOpen = false;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: 'Posts',
            appBar: AppBar(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostCard(
                post: widget.post,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
