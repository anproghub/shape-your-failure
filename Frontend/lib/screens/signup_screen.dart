import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_button.dart';
import 'package:failed_in/components/custom_text_field.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/oscillating_widget.dart';
import 'package:failed_in/models/user_model.dart';
import 'package:failed_in/services/auth_service.dart';
import 'package:failed_in/utilities/alert_box.dart';
import 'package:failed_in/utilities/app_error.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/routes.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validators/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? nameError;
  String? usernameError;
  String? emailError;
  String? passwordError;

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setupListeners();
  }

  @override
  Widget build(BuildContext context) {
    validateData();

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
                                'assets/svg/signup.svg',
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
                                    'Sign Up',
                                    style: TextStyle(
                                      color: kColorPrimaryDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                                  ),
                                  kSpace30Ver,
                                  CustomTextField(
                                    hintText: 'Full name',
                                    controller: nameController,
                                    maxLines: 1,
                                    prefixIcon: FontAwesomeIcons.user,
                                    errorText: nameError,
                                  ),
                                  kSpace30Ver,
                                  CustomTextField(
                                    hintText: 'Choose a username',
                                    controller: usernameController,
                                    maxLines: 1,
                                    prefixIcon: FontAwesomeIcons.at,
                                    errorText: usernameError,
                                  ),
                                  kSpace30Ver,
                                  CustomTextField(
                                    hintText: 'Email',
                                    controller: emailController,
                                    maxLines: 1,
                                    prefixIcon: FontAwesomeIcons.envelope,
                                    keyboardType: TextInputType.emailAddress,
                                    errorText: emailError,
                                  ),
                                  kSpace30Ver,
                                  CustomTextField(
                                    hintText: 'Create a Password',
                                    controller: passwordController,
                                    prefixIcon: FontAwesomeIcons.lock,
                                    maxLines: 1,
                                    obscureText: !isPasswordVisible,
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
                                    errorText: passwordError,
                                  ),
                                  kSpace30Ver,
                                  CustomButton(
                                    text: 'Sign Up',
                                    color: kColorPrimaryDark,
                                    textColor: kColorLight,
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await signupUser();
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
                                Routes.loginScreen,
                              );
                            },
                            child: const Text(
                              'Already have an account? Login.',
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
    nameController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
    usernameController.addListener(() {
      setState(() {});
    });
  }

  void validateData() {
    nameError = nameController.text.isNotEmpty &&
            (nameController.text.length < 2 || nameController.text.length > 40)
        ? 'Name must be 2 - 40 characters long.'
        : null;

    emailError =
        emailController.text.isNotEmpty && !isEmail(emailController.text)
            ? 'Please provide a valid email address.'
            : null;

    usernameError = usernameController.text.isNotEmpty &&
            (usernameController.text.length < 4 ||
                usernameController.text.length > 20)
        ? 'Length of username must be between 4 - 20.'
        : null;

    passwordError = passwordController.text.isNotEmpty &&
            (passwordController.text.length < 8 ||
                passwordController.text.length > 40)
        ? 'Length of username must be between 8 - 40.'
        : null;
  }

  Future<void> signupUser() async {
    if (nameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        nameController.text.length < 2 ||
        nameController.text.length > 40 ||
        usernameController.text.length < 4 ||
        usernameController.text.length > 20 ||
        passwordController.text.length < 8 ||
        passwordController.text.length > 40 ||
        !isEmail(emailController.text)) {
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
      List<String> names = nameController.text.trim().split(' ');
      String firstName = names[0];
      names.removeAt(0);
      String lastName = names.join(' ');

      User user = User(
        firstName: firstName,
        lastName: lastName,
        username: usernameController.text.trim().toLowerCase(),
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text,
      );

      await AuthService.signupUser(user);

      await AlertBox.showSuccessDialog(
        context,
        'Registration successful! Please verify your email address.',
      );

      Navigator.pushReplacementNamed(context, Routes.loginScreen);
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
