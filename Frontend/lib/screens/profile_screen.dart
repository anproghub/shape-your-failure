import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/post_display_card_small.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/services/storage_service.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';
import 'package:failed_in/utilities/routes.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    this.title,
    this.color,
    this.actions,
  }) : super(key: key);

  final Widget? title;
  final Color? color;
  final List<Widget>? actions;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: widget.title,
        actions: widget.actions,
        backgroundColor: widget.color,
        centerTitle: true,
      ),
      backgroundColor: widget.color,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: kColorPrimaryDark,
                          radius: 50,
                          child: CircleAvatar(
                            radius: 49,
                            backgroundImage: NetworkImage(
                              UserApi.instance.image!,
                              headers: {
                                'authorization':
                                    'Bearer ${UserApi.instance.token}',
                              },
                            ),
                          ),
                        ),
                      ),
                      kSpace10Ver,
                      Text(
                        UserApi.instance.username!,
                        style: const TextStyle(
                          color: kColorPrimaryDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      kSpace10Ver,
                      Text(
                        '${UserApi.instance.firstName!} ${UserApi.instance.lastName!}',
                        style: const TextStyle(
                          color: kColorPrimaryDark,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      kSpace10Ver,
                      UserApi.instance.bio != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                UserApi.instance.bio!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: kColorGrey,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Expanded(
                  child: buildBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pagination() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      print('overscroll');
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: StaggeredGridView.countBuilder(
              controller: _controller,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 4,
              itemCount: posts.length,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              staggeredTileBuilder: (int index) {
                return StaggeredTile.count(2, index.isEven ? 2.3 : 1.5);
              },
              itemBuilder: (BuildContext context, int index) {
                return PostDisplayCardSmall(
                  post: posts[index],
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
      'userId=${UserApi.instance.id}&limit=10&page=$page&sort=-createdAt',
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
