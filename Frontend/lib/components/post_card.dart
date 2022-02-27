import 'package:failed_in/components/username_display.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/models/reaction_model.dart';
import 'package:failed_in/models/report_post_model.dart';
import 'package:failed_in/screens/comments_screen.dart';
import 'package:failed_in/screens/edit_post_screen.dart';
import 'package:failed_in/screens/reaction_screen.dart';
import 'package:failed_in/screens/single_post_screen.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/services/reaction_service.dart';
import 'package:failed_in/services/report_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart' as RB;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCard extends StatefulWidget {
  PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  Post post;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isDescriptionOpen = false;
  late int reactionIndex;

  late RB.Reaction initialReaction;

  late List<RB.Reaction> reactions;

  @override
  void initState() {
    super.initState();

    if (widget.post.likeStatus == 'Love') {
      reactionIndex = 0;
    } else if (widget.post.likeStatus == 'BetterLuckNextTime') {
      reactionIndex = 1;
    } else if (widget.post.likeStatus == 'Support') {
      reactionIndex = 2;
    } else if (widget.post.likeStatus == 'Relatable') {
      reactionIndex = 3;
    } else {
      reactionIndex = -1;
    }

    reactions = [
      RB.Reaction(
        title: _buildTitle('Love'),
        previewIcon: _buildReactionsPreviewIcon(
          FontAwesomeIcons.solidHeart,
        ),
        icon: _buildReactionsPreviewIcon(
          FontAwesomeIcons.solidHeart,
        ),
      ),
      RB.Reaction(
        title: _buildTitle('Better Luck Next Time'),
        previewIcon: _buildReactionsPreviewIcon(
          FontAwesomeIcons.sadTear,
        ),
        icon: _buildReactionsPreviewIcon(
          FontAwesomeIcons.sadTear,
        ),
      ),
      RB.Reaction(
        title: _buildTitle('Support'),
        previewIcon: _buildReactionsPreviewIcon(
          FontAwesomeIcons.handHoldingHeart,
        ),
        icon: _buildReactionsPreviewIcon(
          FontAwesomeIcons.handHoldingHeart,
        ),
      ),
      RB.Reaction(
        title: _buildTitle('Relatable'),
        previewIcon: _buildReactionsPreviewIcon(
          Icons.plus_one,
        ),
        icon: _buildReactionsPreviewIcon(
          Icons.plus_one,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: kColorWhite,
        boxShadow: [
          BoxShadow(
            color: kColorGrey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              UsernameDisplay(
                userId: widget.post.userId!,
                username: widget.post.isUserPublic!
                    ? widget.post.username!
                    : 'anonymous',
                userImage: widget.post.userImage!,
                color: kColorPrimaryDark,
                isAnonymous: !widget.post.isUserPublic!,
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: kColorPrimaryDark,
                  size: 16,
                ),
                onSelected: (value) async {
                  switch (value) {
                    case 0:
                      reportPost();
                      break;
                    case 1:
                      await updatePost();
                      break;
                    case 2:
                      await deletePost();
                      break;
                  }
                },
                itemBuilder: (BuildContext buildContext) {
                  if (widget.post.username! != UserApi.instance.username!) {
                    return const [
                      PopupMenuItem(
                        value: 0,
                        child: Text("Report"),
                      ),
                    ];
                  } else {
                    return const [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Edit Post"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Delete Post"),
                      ),
                    ];
                  }
                },
              ),
            ],
          ),
          kSpace10Ver,
          Text(
            widget.post.title!,
            style: const TextStyle(
              color: kColorPrimaryDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          kSpace10Ver,
          widget.post.image != null
              ? AspectRatio(
                  aspectRatio: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SinglePostScreen(
                            post: widget.post,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: widget.post.id!,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.post.image!,
                              headers: {
                                'authorization':
                                    'Bearer ${UserApi.instance.token!}',
                              },
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          kSpace10Ver,
          GestureDetector(
            onTap: () {
              setState(() {
                isDescriptionOpen = !isDescriptionOpen;
              });
            },
            child: Text(
              widget.post.description!,
              style: const TextStyle(
                color: kColorPrimaryDark,
                fontSize: 16,
              ),
              maxLines: isDescriptionOpen ? null : 3,
              overflow: isDescriptionOpen
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
          ),
          kSpace10Ver,
          Text(
            widget.post.postedAt!,
            style: const TextStyle(
              color: kColorGrey,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          kSpace10Ver,
          Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       if (!isLiked) {
              //         widget.post.likeCount = widget.post.likeCount! + 1;
              //         isLiked = true;
              //         likePost();
              //       } else {
              //         widget.post.likeCount = widget.post.likeCount! - 1;
              //         likePost();
              //         isLiked = false;
              //       }
              //     });
              //   },
              //   child: Icon(
              //     isLiked ? Icons.favorite : Icons.favorite_outline,
              //     color: isLiked ? kColorRed : kColorBlueDark,
              //   ),
              // ),
              RB.FlutterReactionButtonCheck(
                boxAlignment: Alignment.centerLeft,
                boxItemsSpacing: 20,
                boxRadius: 10,
                boxPosition: RB.Position.BOTTOM,
                boxPadding: const EdgeInsets.all(
                  15,
                ),
                onReactionChanged: (reaction, index, isChecked) {
                  if (!isChecked) {
                    if (reactionIndex == -1) {
                      return;
                    }

                    widget.post.likeCount = widget.post.likeCount! - 1;
                    likePost('None');
                    reactionIndex = -1;

                    setState(() {});
                  } else {
                    String type = 'Love';

                    if (reactionIndex == -1) {
                      widget.post.likeCount = widget.post.likeCount! + 1;
                    }

                    if (index == 0) {
                      type = 'Love';
                    } else if (index == 1) {
                      type = 'BetterLuckNextTime';
                    } else if (index == 2) {
                      type = 'Support';
                    } else if (index == 3) {
                      type = 'Relatable';
                    }
                    reactionIndex = index == -1 ? 0 : index;

                    setState(() {});
                    likePost(type);
                  }
                },
                reactions: reactions,
                initialReaction: RB.Reaction(
                  icon: const Icon(
                    FontAwesomeIcons.heart,
                    color: kColorPrimaryDark,
                  ),
                ),
                selectedReaction: reactionIndex == -1
                    ? RB.Reaction(
                        icon: const Icon(
                          FontAwesomeIcons.heart,
                          color: kColorPrimaryDark,
                        ),
                      )
                    : reactions[reactionIndex],
                isChecked: reactionIndex != -1,
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReactionsScreen(
                        postId: widget.post.id!,
                      ),
                    ),
                  );
                },
                child: Text(
                  '${widget.post.likeCount!}',
                  style: const TextStyle(
                    color: kColorPrimaryDark,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CommentsScreen(postId: widget.post.id!),
                    ),
                  );
                },
                child: const Icon(
                  Icons.mode_comment_outlined,
                  color: kColorPrimaryDark,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${widget.post.commentsCount!}',
                style: const TextStyle(
                  color: kColorPrimaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TODO: RESOLVE CONTEXT ISSUE
  Future<void> deletePost() async {
    bool sure = await AlertBox.showConfirmationDialog(
        context, 'Delete Post', 'Are you sure? This action can\'t be undone.');
    if (sure) {
      // TODO: Display loading
      try {
        await PostService.deletePost(widget.post.id!);
        await AlertBox.showSuccessDialog(context, 'Post deleted successfully!');
      } on AppError catch (e) {
        await AlertBox.showErrorDialog(context, e);
      }
    }
  }

  Future<void> updatePost() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(post: widget.post),
      ),
    );
  }

  Future<void> reportPost() async {
    List<String> reportArr = [
      'NSFW Content',
      'Hate speech or abusive language.',
      'Spam content',
      'Falunting success',
    ];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Why are you reporting this post?",
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(reportArr.length, (index) {
              return TextButton(
                child: Text(reportArr[index]),
                onPressed: () async {
                  // TODO: Display loading
                  await sendReport(index);
                  Navigator.pop(context);
                },
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> sendReport(int val) async {
    print(val);

    try {
      ReportPost report = ReportPost(
        postId: widget.post.id,
        type: val,
      );
      await ReportService.reportToPost(report);
      await AlertBox.showSuccessDialog(context, 'Reported successfully! 😃');
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(context, e);
    }
  }

  Future<void> likePost(String type) async {
    try {
      await ReactionService.reactToPost(Reaction(
        postId: widget.post.id!,
        reactionType: type,
      ));
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(context, e);
    }
  }

  Widget _buildTitle(String title) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildReactionsPreviewIcon(IconData icon) {
    return Icon(
      icon,
      color: kColorPrimaryDark,
    );
  }
}
