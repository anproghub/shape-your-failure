import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kColorWhite,
          boxShadow: [
            BoxShadow(
              color: kColorGrey.withOpacity(0.5),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: const [
            Icon(
              FontAwesomeIcons.search,
              size: 16,
              color: kColorGrey,
            ),
            kSpace10Hor,
            Text(
              'Search for something...',
              style: TextStyle(
                color: kColorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
