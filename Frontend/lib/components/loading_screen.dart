import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: kColorLight,
      child: Stack(
        children: const [
          AppBackground(),
          Center(
            child: CircularProgressIndicator(
              color: kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
