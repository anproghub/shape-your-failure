enum AppNotificationType {
  Comment,
  Like,
  Report,
  Reply,
}

class AppNotification {
  String? id;
  String? senderId;
  String? receiverId;
  String? postId;
  String? message;
  bool? viewed;
  String? postTitle;
  String? type;
  String? time;

  AppNotification({
    this.id,
    this.senderId,
    this.receiverId,
    this.postId,
    this.postTitle,
    this.message,
    this.viewed,
    this.type,
    this.time,
  });

  static AppNotification fromJson(data) {
    return AppNotification(
      id: data['_id'],
      message: data['message'],
      postId: data['postId']['_id'],
      postTitle: data['postId']['title'],
      senderId: data['senderId']['username'],
      receiverId: data['receiverId'],
      viewed: data['viewed'],
      type: 'AppNotificationType.' + data['type'],
      time: data['createdAt'],
    );
  }
}
