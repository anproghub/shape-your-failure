class Comment {
  String? id;
  String? postId;
  String? userId;
  String? username;
  String? userImage;
  String? description;
  String? parentId;
  String? postedAt;

  Comment({
    this.id,
    this.postId,
    this.userId,
    this.username,
    this.userImage,
    this.description,
    this.parentId,
    this.postedAt,
  });

  static Comment fromJson(data) {
    return Comment(
      id: data['_id'],
      description: data['description'],
      parentId: data['parentId'],
      userId: data['userId']['_id'],
      username: data['userId']['username'],
      userImage: data['userId']['image'],
      postId: data['postId'],
      postedAt: data['createdAt'],
    );
  }

  // TODO: Update fields later
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'parentId': parentId,
    };
  }
}
