import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TagsInputWidget extends StatelessWidget {
  const TagsInputWidget({
    Key? key,
    required this.onTagAdded,
    required this.onTagRemoved,
  }) : super(key: key);

  final Function onTagAdded;
  final Function onTagRemoved;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textFieldStyler: TextFieldStyler(
        isDense: false,
        helperText: '',
        hintText: 'Enter tags',
        hintStyle: const TextStyle(
          color: kColorGrey,
        ),
        textFieldBorder: const UnderlineInputBorder(),
      ),
      tagsStyler: TagsStyler(
        showHashtag: true,
        tagDecoration: BoxDecoration(
          color: kColorGrey.withOpacity(0.2),
        ),
        tagTextStyle: const TextStyle(
          color: kColorPrimaryDark,
          fontStyle: FontStyle.italic,
          fontSize: 16,
        ),
        tagCancelIcon: const Icon(
          Icons.cancel,
          size: 16,
          color: kColorPrimaryDark,
        ),
      ),
      onTag: (tag) {
        onTagAdded(tag);
      },
      onDelete: (tag) {
        onTagRemoved(tag);
      },
      validator: (tag) {
        if (tag.length > 20) {
          return "hey that's too long";
        }
        return null;
      },
    );
  }
}
