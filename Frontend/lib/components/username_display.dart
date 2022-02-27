import 'package:failed_in/screens/user_screen.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';

class UsernameDisplay extends StatelessWidget {
  const UsernameDisplay({
    Key? key,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.color,
    required this.isAnonymous,
  }) : super(key: key);

  final String userId;
  final String username;
  final String userImage;
  final Color color;
  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isAnonymous) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserScreen(userId: userId),
            ),
          );
        }
      },
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(
            child: CircleAvatar(
              backgroundImage: !isAnonymous
                  ? NetworkImage(
                      userImage,
                      headers: {
                        'authorization': 'Bearer ${UserApi.instance.token!}',
                      },
                    )
                  : null,
              backgroundColor:
                  !isAnonymous ? Colors.transparent : kColorPrimaryDark,
              radius: 9,
            ),
            backgroundColor: color,
            radius: 10,
          ),
          kSpace10Hor,
          Text(
            isAnonymous ? 'anonymous' : username,
            style: TextStyle(
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
