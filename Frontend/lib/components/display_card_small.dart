import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/post_display_card_small.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/screens/posts_screen.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

class DisplayCardSmall extends StatefulWidget {
  const DisplayCardSmall({
    Key? key,
    required this.title,
    required this.query,
  }) : super(key: key);

  final String title;
  final String query;

  @override
  _DisplayCardSmallState createState() => _DisplayCardSmallState();
}

class _DisplayCardSmallState extends State<DisplayCardSmall> {
  List<Post> posts = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    loadUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: kColorPrimaryDark,
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostsScreen(
                        query: widget.query,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: kColorGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 2 / 1,
          child: !isLoading
              ? posts.isEmpty
                  ? const Center(
                      child: Text(
                        'Noting to display',
                        style: TextStyle(
                          color: kColorGrey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(left: 20, right: 5),
                          child: PostDisplayCardSmall(
                            post: posts[index],
                          ),
                        );
                      },
                    )
              : const LoadingScreen(),
        ),
      ],
    );
  }

  Future<void> loadUserPosts() async {
    setState(() {
      isLoading = true;
    });

    List<Post> postList =
        await PostService.getUsersPosts('limit=5&page=1&${widget.query}');
    posts = postList;

    setState(() {
      isLoading = false;
    });
  }
}
