import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/custom_button.dart';
import 'package:failed_in/components/custom_text_field.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/oscillating_widget.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  Post post;

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? titleError;
  String? descriptionError;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setupListeners();
  }

  @override
  Widget build(BuildContext context) {
    validateInput();

    if (!isLoading) {
      return Stack(
        children: [
          const AppBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              title: 'Edit Post',
              appBar: AppBar(),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: OscillatingWidget(
                      amplitude: 20,
                      child: SvgPicture.asset(
                        'assets/svg/update.svg',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: CustomTextField(
                    hintText: 'Enter title',
                    controller: titleController,
                    errorText: titleError,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: CustomTextField(
                    hintText: 'Enter description',
                    controller: descriptionController,
                    errorText: descriptionError,
                    maxLines: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: CustomButton(
                    text: 'Update post',
                    color: kColorPrimaryDark,
                    textColor: kColorLight,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await updatePost();
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const LoadingScreen();
    }
  }

  void setupListeners() {
    titleController.text = widget.post.title!;
    descriptionController.text = widget.post.description!;
    titleController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });
  }

  void validateInput() {
    titleError = titleController.text.isNotEmpty &&
            (titleController.text.trim().length < 4 ||
                titleController.text.trim().length > 40)
        ? 'Title length must be between 4 - 40'
        : null;
    descriptionError = descriptionController.text.isNotEmpty &&
            (descriptionController.text.trim().length < 4 ||
                descriptionController.text.trim().length > 500)
        ? 'Title length must be between 4 - 500'
        : null;
  }

  Future<void> updatePost() async {
    if (titleController.text.isEmpty ||
        titleController.text.trim().length < 4 ||
        titleController.text.trim().length > 40 ||
        descriptionController.text.isEmpty ||
        descriptionController.text.trim().length < 4 ||
        descriptionController.text.trim().length > 500) {
      await AlertBox.showErrorDialog(
        context,
        AppError(
          400,
          'Please enter valid data!',
        ),
      );

      return;
    }

    try {
      widget.post.title = titleController.text.trim();
      widget.post.description = descriptionController.text.trim();
      await PostService.updatePost(widget.post);
      AlertBox.showSuccessDialog(context, 'Post updated successfully! 😃');
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(
        context,
        e,
      );
    }
  }
}
