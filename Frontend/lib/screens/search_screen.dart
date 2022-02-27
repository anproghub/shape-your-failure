import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/custom_text_field.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/post_display_card.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Post> posts = [];

  int page = 1;
  bool isLoading = false;
  bool moreDataPresent = true;
  bool loadingMoreData = false;
  String prevText = "";

  TextEditingController searchController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(pagination);
    searchController.addListener(() {
      if (searchController.text.trim().isNotEmpty &&
          searchController.text.trim() != prevText) {
        moreDataPresent = true;
        prevText = searchController.text.trim();
        loadingMoreData = false;
        page = 1;
        posts = [];
        loadUserPosts();
      }

      if (searchController.text.trim().isEmpty) {
        isLoading = false;
        loadingMoreData = false;
        moreDataPresent = true;
        posts = [];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            appBar: AppBar(),
            title: 'Search for posts',
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: CustomTextField(
                  hintText: 'Search for something...',
                  prefixIcon: Icons.search,
                  controller: searchController,
                  maxLines: 1,
                ),
              ),
              Expanded(
                child: buildBody(),
              ),
            ],
          ),
        ),
      ],
    );
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
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  child: AspectRatio(
                    aspectRatio: 5.5 / 3,
                    child: PostDisplayCard(
                      post: posts[index],
                    ),
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

  Future<void> loadUserPosts() async {
    setState(() {
      page == 1 ? isLoading = true : loadingMoreData = true;
    });

    try {
      // TODO: Handle lowercase search on server
      List<Post> postList = await PostService.getUsersPosts(
        'limit=5&page=$page&sort=-createdAt&searchFor=title&matchWith=${searchController.text.trim()}',
      );

      if (postList.isEmpty) {
        moreDataPresent = false;
      } else {
        if (page == 1) {
          posts = [];
        }
        posts.addAll(postList);
      }
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(context, e);
    }

    setState(() {
      page == 1 ? isLoading = false : loadingMoreData = false;
    });
  }
}
