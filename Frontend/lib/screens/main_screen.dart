// ignore_for_file: prefer_const_constructors

import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_bottom_navigation_bar.dart';
import 'package:failed_in/screens/home_screen.dart';
import 'package:failed_in/screens/upload_post_screen.dart';
import 'package:failed_in/services/storage_service.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/routes.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';
import 'package:failed_in/screens/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    print(UserApi.instance.email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Stack(
        children: [
          AppBackground(),
          Padding(
            padding: const EdgeInsets.only(
              bottom: kBottomNavigationBarHeight,
            ),
            child: getCurrentPage(),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return UploadPostScreen(
          color: Colors.transparent,
          title: Text(
            'FailedIn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            getActionButton(),
          ],
        );
      case 1:
        return HomeScreen(
          color: Colors.transparent,
          title: Text(
            'FailedIn',
            style: TextStyle(
              color: kColorPrimaryDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            getActionButton(),
          ],
        );
      case 2:
        return ProfileScreen(
          color: Colors.transparent,
          title: Text(
            'FailedIn',
            style: TextStyle(
              color: kColorPrimaryDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            getActionButton(),
          ],
        );
    }
    return Container();
  }

  Widget getActionButton() {
    switch (_currentIndex) {
      case 0:
        return Container();
      case 1:
        return IconButton(
          icon: Icon(FontAwesomeIcons.bell),
          color: kColorPrimaryDark,
          onPressed: () {
            Navigator.pushNamed(context, Routes.notificationScreen);
          },
        );
      case 2:
        return PopupMenuButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: kColorPrimaryDark,
          ),
          onSelected: (value) async {
            switch (value) {
              case 0:
                Navigator.pushNamed(context, Routes.editProfileScreen);
                break;
              case 1:
                await logout();
                break;
            }
          },
          itemBuilder: (BuildContext buildContext) {
            return [
              PopupMenuItem(
                value: 0,
                child: Text("Edit profile"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Logout"),
              ),
            ];
          },
        );
    }
    return Container();
  }

  Future<void> logout() async {
    await StorageService.storeJWT("");
    Navigator.pushReplacementNamed(context, Routes.loginScreen);
  }
}
