import 'dart:ui';

import 'package:failed_in/components/display_card.dart';
import 'package:failed_in/components/display_card_small.dart';
import 'package:failed_in/components/search_bar.dart';
import 'package:failed_in/screens/bot_screen.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:failed_in/utilities/routes.dart';
import 'package:failed_in/utilities/spacing.dart';
import 'package:failed_in/utilities/user_api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    this.title,
    this.color,
    this.actions,
  }) : super(key: key);

  final Widget? title;
  final Color? color;
  final List<Widget>? actions;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: widget.title,
        actions: widget.actions,
        backgroundColor: widget.color,
        centerTitle: true,
      ),
      backgroundColor: widget.color,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'Hey ${UserApi.instance.firstName},',
                      style: const TextStyle(
                        color: kColorPrimaryDark,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: SearchBar(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.searchScreen);
                      },
                    ),
                  ),
                  kSpace10Ver,
                  const DisplayCard(
                    title: 'RECENT UPLOADS',
                    query: 'sort=-createdAt',
                  ),
                  kSpace10Ver,
                  const DisplayCardSmall(
                    title: 'MOST LIKED',
                    query: 'sort=-likeCount',
                  ),
                  kSpace10Ver,
                  const DisplayCard(
                    title: 'MADE FOR YOU',
                    query: 'sort=-likeCount',
                    isRecommended: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePageDialogflow()));
        },
        child: const Icon(Icons.chat_bubble),
        backgroundColor: kColorPrimary,
      ),
    );
  }
}
