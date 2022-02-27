import 'dart:io';
import 'package:failed_in/components/custom_button.dart';
import 'package:failed_in/components/custom_text_field.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/tags_input_widget.dart';
import 'package:failed_in/models/post_model.dart';
import 'package:failed_in/services/post_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({
    Key? key,
    this.title,
    this.color,
    this.actions,
  }) : super(key: key);

  final Widget? title;
  final Color? color;
  final List<Widget>? actions;

  @override
  _UploadPostScreenState createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? titleError;
  String? descriptionError;
  bool isUserPublic = false;
  bool isLoading = false;

  Set<String> tags = {};

  File? imageFile;

  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    setupListeners();
  }

  @override
  Widget build(BuildContext context) {
    validateInput();

    if (!isLoading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: widget.title,
          actions: widget.actions,
          backgroundColor: kColorPrimary,
          centerTitle: true,
        ),
        backgroundColor: widget.color,
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.7,
                      color: kColorPrimary,
                      child: const Text(
                        " Flaunt" + "\n" + " Your Failure.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: titleController,
                          hintText: 'Enter post title',
                          maxLines: 1,
                          errorText: titleError,
                        ),
                        kSpace10Ver,
                        CustomTextField(
                          controller: descriptionController,
                          hintText: 'Enter post description',
                          maxLines: 10,
                          errorText: descriptionError,
                        ),
                        kSpace10Ver,
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: () async {
                              await _getFromGallery();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kColorPrimary,
                                ),
                              ),
                              child: Material(
                                child: Center(
                                  child: imageFile != null
                                      ? Image(
                                          image: FileImage(imageFile!),
                                        )
                                      : const Icon(
                                          Icons.add_a_photo_outlined,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        kSpace30Ver,
                        TagsInputWidget(
                          onTagAdded: (tagName) {
                            tags.add(tagName);
                          },
                          onTagRemoved: (tagName) {
                            tags.remove(tagName);
                          },
                        ),
                        kSpace10Ver,
                        Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Post anonymously',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Switch(
                              value: isUserPublic,
                              onChanged: (value) {
                                setState(() {
                                  isUserPublic = value;
                                });
                              },
                            ),
                          ],
                        ),
                        kSpace10Ver,
                        CustomButton(
                          color: kColorPrimary,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await uploadPost();
                            setState(() {
                              isLoading = false;
                            });
                          },
                          text: 'Upload post',
                          textColor: kColorLight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const LoadingScreen();
    }
  }

  void setupListeners() {
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
        ? 'Description length must be between 4 - 500'
        : null;
  }

  /// Pick an image from gallery
  Future<void> _getFromGallery() async {
    File? pickedFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    //await getLostData();
    if (pickedFile != null) {
      await _cropImage(pickedFile.path);
    }
  }

  /// Function to prevent destruction of main activity on android
  // Future<void> getLostData() async {
  //   final LostDataResponse response = await picker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.files != null) {
  //     for (XFile file in response.files!) {
  //       setState(() {
  //         imageFile = File(file.path);
  //       });
  //     }
  //   }
  // }

  /// Crop the picked image
  Future<void> _cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    //await getLostData();
    if (croppedImage != null) {
      imageFile = croppedImage;
      setState(() {});
    }
  }

  Future<void> uploadPost() async {
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

      tags.clear();
      return;
    }

    try {
      await PostService.uploadPost(
        Post(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          isUserPublic: !isUserPublic,
          tags: tags.toList(),
        ),
        imageFile,
      );
      tags.clear();
      AlertBox.showSuccessDialog(context, 'Failure uploaded successfully! 😃');
    } on AppError catch (e) {
      tags.clear();
      await AlertBox.showErrorDialog(
        context,
        e,
      );
    }
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
