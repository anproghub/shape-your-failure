import 'package:failed_in/models/notification_model.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    Color color = notification.viewed! ? kColorGrey : kColorPrimaryDark;

    if (notification.type == AppNotificationType.Report.toString()) {
      return Text(
        notification.message!,
        style: TextStyle(
          color: color,
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: notification.senderId!,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: notification.type == AppNotificationType.Comment.toString()
                  ? ' commented on your post.'
                  : (notification.type == AppNotificationType.Comment.toString()
                      ? ' liked your post.'
                      : ' replied to a comment on your post.'),
              style: TextStyle(
                color: color,
              ),
            ),
            TextSpan(
              text: '\n${notification.time!}',
              style: const TextStyle(
                color: kColorGrey,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      );
    }
  }
}
