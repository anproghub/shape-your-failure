import 'package:failed_in/components/app_background.dart';
import 'package:failed_in/components/custom_app_bar.dart';
import 'package:failed_in/components/loading_screen.dart';
import 'package:failed_in/components/notification_card.dart';
import 'package:failed_in/services/notification_service.dart';
import 'package:failed_in/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:failed_in/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> notifications = [];

  bool isLoading = false;
  bool loadingMoreData = false;
  bool moreDataPresent = true;
  int page = 1;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(pagination);
    loadNotifications();
  }

  void pagination() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (moreDataPresent) {
        page++;
        if (!loadingMoreData) {
          loadNotifications();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No more notifications!"),
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
            title: 'Notifications',
            appBar: AppBar(),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              notifications = [];
              page = 1;
              moreDataPresent = true;
              loadingMoreData = false;
              loadNotifications();
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
              itemCount: notifications.length,
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(vertical: 0.5),
                  color: kColorLight,
                  child: NotificationCard(
                    notification: notifications[index],
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

  Future<void> loadNotifications() async {
    setState(() {
      page == 1 ? isLoading = true : loadingMoreData = true;
    });

    List<AppNotification> notificationList =
        await await NotificationService.getAllNotifications(
      'sort=-createdAt&limit=20&page=$page',
    );

    if (notificationList.isEmpty) {
      moreDataPresent = false;
    } else {
      notifications.addAll(notificationList);
    }

    setState(() {
      page == 1 ? isLoading = false : loadingMoreData = false;
    });
  }
}
