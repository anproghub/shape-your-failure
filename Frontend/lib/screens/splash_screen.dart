import 'package:failed_in/services/auth_service.dart';
import 'package:failed_in/services/storage_service.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/routes.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'FailedIn',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: kColorLight,
              ),
            ),
            kSpace50Ver,
            CircularProgressIndicator(
              color: kColorLight,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadUserInfo() async {
    String token = await StorageService.fetchJWT();
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    } else {
      try {
        await AuthService.loadUserData(token);
        Navigator.pushReplacementNamed(context, Routes.mainScreen);
      } on AppError catch (e) {
        Navigator.pushReplacementNamed(context, Routes.loginScreen);
      }
    }
  }
}
