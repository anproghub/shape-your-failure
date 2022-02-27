import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/comment_card.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/custom_text_field.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/models/comment_model.dart';
import 'package:failed_in/services/comment_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  final String postId;

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Comment> comments = [];

  bool isLoading = false;
  bool loadingMoreData = false;
  bool moreDataPresent = true;
  int page = 1;

  String? replyTo;
  String? replyToName;

  final ScrollController _controller = ScrollController();

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(pagination);
    loadPostComments();
  }

  void pagination() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (moreDataPresent) {
        page++;
        if (!loadingMoreData) {
          loadPostComments();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No more comments!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: 'Comments',
            appBar: AppBar(),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              comments = [];
              page = 1;
              moreDataPresent = true;
              loadingMoreData = false;
              loadPostComments();
            },
            child: buildBody(),
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
              itemCount: comments.length,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              controller: _controller,
              itemBuilder: (context, index) {
                return CommentCard(
                  comment: comments[index],
                  onReply: (String commentId, String name) {
                    setState(() {
                      replyTo = commentId;
                      replyToName = name;
                    });
                  },
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              replyTo != null
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      color: kColorPrimary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reply to $replyToName',
                            style: const TextStyle(
                              color: kColorLight,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                replyTo = null;
                                replyToName = null;
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: kColorLight,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'Post a comment',
                      controller: commentController,
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.solidPaperPlane,
                      color: kColorPrimaryDark,
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await postAComment();
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
  }

  Future<void> loadPostComments() async {
    setState(() {
      page == 1 ? isLoading = true : loadingMoreData = true;
    });

    List<Comment> commentList = await CommentService.loadCommentsInPost(
      widget.postId,
      'sort=createdAt&limit=20&page=$page',
    );

    if (commentList.isEmpty) {
      moreDataPresent = false;
    } else {
      comments.addAll(commentList);
    }

    setState(() {
      page == 1 ? isLoading = false : loadingMoreData = false;
    });
  }

  Future<void> postAComment() async {
    if (commentController.text.trim().isEmpty ||
        commentController.text.trim().length > 150) {
      await AlertBox.showErrorDialog(
        context,
        AppError(
          400,
          'Please post a valid comment. (Comment size must be between 0-150)',
        ),
      );
      return;
    }

    try {
      await CommentService.postComment(Comment(
        description: commentController.text.trim(),
        postId: widget.postId,
        parentId: replyTo,
      ));

      page = 1;
      comments = [];
      await loadPostComments();
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(context, e);
    }
  }
}
