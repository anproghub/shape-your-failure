import 'package:failed_in/screens/edit_profile_screen.dart';
import 'package:failed_in/screens/home_screen.dart';
import 'package:failed_in/screens/login_screen.dart';
import 'package:failed_in/screens/notifications_screen.dart';
import 'package:failed_in/screens/posts_screen.dart';
import 'package:failed_in/screens/search_screen.dart';
import 'package:failed_in/screens/signup_screen.dart';
import 'package:failed_in/screens/splash_screen.dart';
import 'package:failed_in/screens/main_screen.dart';
import 'package:failed_in/services/storage_service.dart';
import 'package:failed_in/utilities/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Failed In',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'CarosSoft',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      routes: {
        Routes.splashScreen: (context) => const SplashScreen(),
        Routes.loginScreen: (context) => const LoginScreen(),
        Routes.signupScreen: (context) => const SignupScreen(),
        Routes.homeScreen: (context) => const HomeScreen(),
        Routes.mainScreen: (context) => const MainScreen(),
        Routes.notificationScreen: (context) => const NotificationsScreen(),
        Routes.editProfileScreen: (context) => const EditProfileScreen(),
        Routes.searchScreen: (context) => const SearchScreen(),
      },
    );
  }
}
