import 'dart:io';

import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/custom_button.dart';
import 'package:failed_in/components/custom_text_field.dart';
import 'package:failed_in/components/oscillating_widget.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? imageFile;
  ImagePicker picker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  String? nameError;
  String? bioError;

  @override
  void initState() {
    super.initState();

    setupListeners();
  }

  @override
  Widget build(BuildContext context) {
    validateInput();

    return Stack(children: [
      const AppBackground(),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: "Edit Profile",
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      //color: Colors.red,
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: OscillatingWidget(
                        amplitude: 20,
                        child: SvgPicture.asset(
                          'assets/svg/update.svg',
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Enter your name',
                      maxLines: 1,
                      errorText: nameError,
                    ),
                    kSpace10Ver,
                    CustomTextField(
                      controller: bioController,
                      hintText: 'Enter about',
                      maxLines: 1,
                      errorText: bioError,
                    ),
                    kSpace10Ver,
                    CustomButton(
                      text: imageFile != null ? 'Remove photo' : 'Upload photo',
                      color: kColorPrimary,
                      onPressed: () async {
                        if (imageFile == null) {
                          await _getFromGallery();
                        } else {
                          imageFile = null;
                          setState(() {});
                        }
                      },
                      textColor: kColorLight,
                    ),
                    kSpace30Ver,
                    CustomButton(
                      color: kColorPrimary,
                      onPressed: () async {},
                      text: 'Update profile',
                      textColor: kColorLight,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  void setupListeners() {
    nameController.text =
        UserApi.instance.firstName! + ' ' + UserApi.instance.lastName!;
    bioController.text =
        UserApi.instance.bio != null ? UserApi.instance.bio! : '';

    nameController.addListener(() {
      setState(() {});
    });
    bioController.addListener(() {
      setState(() {});
    });
  }

  void validateInput() {
    nameError = nameController.text.isNotEmpty &&
            (nameController.text.trim().length < 2 ||
                nameController.text.trim().length > 40)
        ? 'Name length must be between 2 - 40'
        : null;
    bioError = bioController.text.isNotEmpty &&
            (bioController.text.trim().length < 4 ||
                bioController.text.trim().length > 150)
        ? 'Bio length must be between 4 - 500'
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
}
