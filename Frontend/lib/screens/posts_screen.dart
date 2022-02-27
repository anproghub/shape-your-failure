import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/post_card.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    Key? key,
    required this.query,
    this.isRecommended = false,
  }) : super(key: key);

  final String query;
  final bool isRecommended;

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> posts = [];

  int page = 1;
  bool isLoading = false;
  bool moreDataPresent = true;
  bool loadingMoreData = false;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(pagination);

    loadUserPosts();
  }

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
          body: RefreshIndicator(
            onRefresh: () async {
              posts = [];
              page = 1;
              moreDataPresent = true;
              loadingMoreData = false;
              loadUserPosts();
            },
            child: buildBody(),
          ),
        ),
      ],
    );
  }

  void pagination() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (moreDataPresent) {
        page++;
        if (!loadingMoreData) {
          loadUserPosts();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No more posts!"),
          ),
        );
      }
    }
  }

  Widget buildBody() {
    if (isLoading) {
      return const LoadingScreen();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: PostCard(
                    post: posts[index],
                  ),
                );
              },
            ),
          ),
          loadingMoreData
              ? Center(
                  child: Container(
                    transform: Matrix4.identity()..scale(0.5),
                    child: const CircularProgressIndicator(
                      color: kColorPrimaryDark,
                    ),
                  ),
                )
              : Container(),
        ],
      );
    }
  }

  Future<void> loadUserPosts() async {
    setState(() {
      page == 1 ? isLoading = true : loadingMoreData = true;
    });

    List<Post> postList = await PostService.getUsersPosts(
      'limit=5&page=$page&${widget.query}',
      isRecommended: widget.isRecommended,
    );

    if (postList.isEmpty) {
      moreDataPresent = false;
    } else {
      posts.addAll(postList);
    }

    setState(() {
      page == 1 ? isLoading = false : loadingMoreData = false;
    });
  }
}
