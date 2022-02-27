import 'package:failed_in/models/reaction_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReactionCard extends StatelessWidget {
  const ReactionCard({
    Key? key,
    required this.reaction,
  }) : super(key: key);

  final Reaction reaction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          reaction.username!,
        ),
        Icon(
          getIcon(),
          size: 16,
        ),
      ],
    );
  }

  IconData getIcon() {
    if (reaction.reactionType == 'Love') {
      return FontAwesomeIcons.solidHeart;
    } else if (reaction.reactionType == 'BetterLuckNextTime') {
      return FontAwesomeIcons.sadTear;
    } else if (reaction.reactionType == 'Support') {
      return FontAwesomeIcons.handHoldingHeart;
    } else if (reaction.reactionType == 'Relatable') {
      return Icons.plus_one;
    }
    return FontAwesomeIcons.solidHeart;
  }
}
