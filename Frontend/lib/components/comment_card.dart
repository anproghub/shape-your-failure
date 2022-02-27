import 'package:failed_in/components/reply_card.dart';
import 'package:failed_in/components/username_display.dart';
import 'package:failed_in/models/comment_model.dart';
import 'package:failed_in/models/report_comment_model.dart';
import 'package:failed_in/services/comment_service.dart';
import 'package:failed_in/services/report_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    Key? key,
    required this.comment,
    required this.onReply,
  }) : super(key: key);
  final Comment comment;
  final Function onReply;
  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  List<Comment> replies = [];

  bool loadingMoreData = false;
  bool moreDataPresent = true;
  int page = 0;

  bool isRepliesOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              UsernameDisplay(
                userId: widget.comment.userId!,
                username: widget.comment.username!,
                userImage: widget.comment.userImage!,
                isAnonymous: false,
                color: kColorPrimaryDark,
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
                      reportComment();
                      break;
                    case 1:
                      await deleteComment();
                      break;
                  }
                },
                itemBuilder: (BuildContext buildContext) {
                  if (widget.comment.username! != UserApi.instance.username!) {
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
                        child: Text("Delete comment"),
                      ),
                    ];
                  }
                },
              ),
            ],
          ),
          kSpace10Ver,
          Text(
            widget.comment.description!,
          ),
          kSpace10Ver,
          Text(
            widget.comment.postedAt!,
            style: const TextStyle(
              color: kColorGrey,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          kSpace10Ver,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  widget.onReply(
                    widget.comment.id!,
                    widget.comment.username!,
                  );
                },
                child: const Text(
                  'Reply',
                  style: TextStyle(
                    color: kColorPrimary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              kSpace10Hor,
              GestureDetector(
                onTap: () {
                  onLoadRepliesClicked();
                },
                child: Text(
                  !isRepliesOpen
                      ? 'View replies'
                      : (moreDataPresent
                          ? 'Load previous replies'
                          : 'Hide replies'),
                  style: const TextStyle(
                    color: kColorPrimary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          buildRepliesWidget(),
        ],
      ),
    );
  }

  Future<void> reportComment() async {
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
    try {
      ReportComment report = ReportComment(
        commentId: widget.comment.id,
        postId: widget.comment.postId,
        type: val,
      );
      await ReportService.reportToComment(report);
      AlertBox.showSuccessDialog(context, 'Reported successfully! 😃');
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(context, e);
    }
  }

  void onLoadRepliesClicked() {
    if (!loadingMoreData) {
      if (!moreDataPresent) {
        setState(() {
          isRepliesOpen = !isRepliesOpen;
        });
      } else {
        page++;
        isRepliesOpen = true;
        loadReplies();
      }
    }
  }

  Widget buildRepliesWidget() {
    if (isRepliesOpen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
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
            mainAxisSize: MainAxisSize.min,
            children: List.generate(replies.length, (index) {
              return ReplyCard(
                comment: replies[replies.length - 1 - index],
              );
            }),
          ),
          !loadingMoreData && replies.isEmpty
              ? const Text(
                  'No replies yet',
                  style: TextStyle(
                    color: kColorGrey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                )
              : Container(),
        ],
      );
    } else {
      return Container();
    }
  }

  Future<void> deleteComment() async {
    // TODO: Display loading
    try {
      await CommentService.deleteComment(widget.comment);

      // TODO: Refresh state
      await AlertBox.showSuccessDialog(
          context, 'Comment deleted successfully!');
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(context, e);
    }
  }

  Future<void> loadReplies() async {
    if (!moreDataPresent) {
      return;
    }
    setState(() {
      loadingMoreData = true;
    });

    List<Comment> replyList = await CommentService.loadRepliesInComment(
      widget.comment.postId!,
      widget.comment.id!,
      'sort=-createdAt&limit=3&page=$page',
    );

    if (replyList.isEmpty) {
      moreDataPresent = false;
    } else {
      replies.addAll(replyList);
    }

    setState(() {
      loadingMoreData = false;
    });
  }
}
