import 'package:failed_in/components/custom_button.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class AlertBox {
  static Future<void> showErrorDialog(
      BuildContext context, AppError error) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Error!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kColorRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              kSpace30Ver,
              Text(error.message),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            CustomButton(
              text: 'Okay',
              color: kColorPrimary,
              textColor: kColorLight,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSuccessDialog(
      BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Success',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kColorRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              kSpace30Ver,
              Text(message),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            CustomButton(
              text: 'Okay',
              color: kColorPrimary,
              textColor: kColorLight,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showConfirmationDialog(
      BuildContext context, String title, String message) async {
    bool sure = false;

    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Container();
    //   },
    // );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kColorRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              kSpace30Ver,
              Text(message),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            CustomButton(
              text: 'Cancel',
              color: kColorPrimary,
              textColor: kColorLight,
              onPressed: () {
                sure = false;
                Navigator.pop(context);
              },
            ),
            CustomButton(
              text: 'Yes',
              color: kColorPrimary,
              textColor: kColorLight,
              onPressed: () {
                sure = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    return sure;
  }
}
