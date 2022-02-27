import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_button.dart';
import 'package:failed_in/components/custom_text_field.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/oscillating_widget.dart';
import 'package:failed_in/services/auth_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/routes.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setupListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Stack(
        children: [
          const AppBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: OscillatingWidget(
                              amplitude: 20,
                              child: SvgPicture.asset(
                                'assets/svg/login.svg',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: kColorPrimaryDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                                  ),
                                  kSpace30Ver,
                                  CustomTextField(
                                    hintText: 'Email',
                                    controller: emailController,
                                    prefixIcon: FontAwesomeIcons.at,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  kSpace30Ver,
                                  CustomTextField(
                                    hintText: 'Password',
                                    controller: passwordController,
                                    prefixIcon: FontAwesomeIcons.lock,
                                    obscureText: !isPasswordVisible,
                                    maxLines: 1,
                                    suffix: passwordController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isPasswordVisible =
                                                    !isPasswordVisible;
                                              });
                                            },
                                            child: Icon(
                                              isPasswordVisible
                                                  ? FontAwesomeIcons.eyeSlash
                                                  : FontAwesomeIcons.eye,
                                              color: kColorGrey,
                                            ),
                                          )
                                        : null,
                                  ),
                                  kSpace30Ver,
                                  CustomButton(
                                    text: 'Login',
                                    color: kColorPrimaryDark,
                                    textColor: kColorLight,
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await loginUser();
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.signupScreen,
                              );
                            },
                            child: const Text(
                              'Don\'t have an account? Register.',
                              style: TextStyle(
                                color: kColorPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return const LoadingScreen();
    }
  }

  void setupListeners() {
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      await AlertBox.showErrorDialog(
        context,
        AppError(
          400,
          'Please provide valid input.',
        ),
      );
      return;
    }

    try {
      await AuthService.loginUser(
        emailController.text.trim().toLowerCase(),
        passwordController.text,
      );

      Navigator.pushReplacementNamed(context, Routes.mainScreen);
    } on AppError catch (e) {
      await AlertBox.showErrorDialog(
        context,
        AppError(
          400,
          e.message,
        ),
      );
    }
  }
}
