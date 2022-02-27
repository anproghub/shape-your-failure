import 'package:failed_in/components/username_display.dart';
import 'package:failed_in/models/comment_model.dart';
import 'package:failed_in/services/comment_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 30,
        top: 10,
        bottom: 10,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                userId: comment.userId!,
                username: comment.username!,
                userImage: comment.userImage!,
                color: kColorPrimaryDark,
                isAnonymous: false,
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: kColorPrimaryDark,
                  size: 16,
                ),
                onSelected: (value) async {
                  switch (value) {
                    case 0: // TODO: Report functionality
                      break;
                    case 1:
                      await deleteComment(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext buildContext) {
                  if (comment.username! != UserApi.instance.username!) {
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
            comment.description!,
          ),
          kSpace10Ver,
          Text(
            comment.postedAt!,
            style: const TextStyle(
              color: kColorGrey,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteComment(context) async {
    // TODO: Display loading
    try {
      await CommentService.deleteComment(comment);

      // TODO: Refresh state
      await AlertBox.showSuccessDialog(
          context, 'Comment deleted successfully!');
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(context, e);
    }
  }
}
