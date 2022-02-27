import 'package:failed_in/components/post_display_card.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/screens/posts_screen.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

import 'loading_screen.dart';

class DisplayCard extends StatefulWidget {
  const DisplayCard({
    Key? key,
    required this.title,
    required this.query,
    this.isRecommended = false,
  }) : super(key: key);

  final String title;
  final String query;
  final bool isRecommended;

  @override
  _DisplayCardState createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
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
                        isRecommended: widget.isRecommended,
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
          aspectRatio: 5.5 / 3,
          child: SizedBox(
            width: double.infinity,
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
                    : PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return PostDisplayCard(
                            post: posts[index],
                          );
                        },
                      )
                : const LoadingScreen(),
          ),
        ),
      ],
    );
  }

  Future<void> loadUserPosts() async {
    setState(() {
      isLoading = true;
    });

    List<Post> postList = await PostService.getUsersPosts(
      'limit=5&page=1&${widget.query}',
      isRecommended: widget.isRecommended,
    );
    posts = postList;

    setState(() {
      isLoading = false;
    });
  }
}
