import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/reaction_card.dart';
import 'package:failed_in/models/reaction_model.dart';
import 'package:failed_in/services/reaction_service.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';

class ReactionsScreen extends StatefulWidget {
  const ReactionsScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  final String postId;

  @override
  _ReactionsScreenState createState() => _ReactionsScreenState();
}

class _ReactionsScreenState extends State<ReactionsScreen> {
  List<Reaction> reactions = [];

  bool isLoading = false;
  bool loadingMoreData = false;
  bool moreDataPresent = true;
  int page = 1;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(pagination);
    loadReactions();
  }

  void pagination() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (moreDataPresent) {
        page++;
        if (!loadingMoreData) {
          loadReactions();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No more reactions!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: 'Reactions',
            appBar: AppBar(),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              reactions = [];
              page = 1;
              moreDataPresent = true;
              loadingMoreData = false;
              loadReactions();
            },
            child: buildBody(),
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const LoadingScreen();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reactions.length,
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(vertical: 0.5),
                  child: ReactionCard(
                    reaction: reactions[index],
                  ),
                );
              },
            ),
          ),
          loadingMoreData
              ? Center(
                  child: Container(
                    transform: Matrix4.identity()..scale(0.5),
                    child: const CircularProgressIndicator(
                      color: kColorPrimaryDark,
                    ),
                  ),
                )
              : Container(),
        ],
      );
    }
  }

  Future<void> loadReactions() async {
    setState(() {
      page == 1 ? isLoading = true : loadingMoreData = true;
    });

    List<Reaction> reactionList = await ReactionService.getAllReactions(
      widget.postId,
      'sort=-createdAt&limit=20&page=$page',
    );

    if (reactionList.isEmpty) {
      moreDataPresent = false;
    } else {
      reactions.addAll(reactionList);
    }

    setState(() {
      page == 1 ? isLoading = false : loadingMoreData = false;
    });
  }
}
