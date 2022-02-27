class Post {
  String? id;
  String? userId;
  String? username;
  String? userImage;
  String? title;
  String? description;
  bool? isUserPublic;
  String? image;
  List<String>? tags;
  int? likeCount;
  int? commentsCount;
  String? postedAt;
  String? likeStatus;

  Post({
    this.id,
    this.userId,
    this.username,
    this.userImage,
    this.title,
    this.description,
    this.isUserPublic,
    this.image,
    this.tags,
    this.likeCount = 0,
    this.postedAt,
    this.commentsCount = 0,
    this.likeStatus = 'None',
  });

  // TODO: Update this
  static Post fromJson(data) {
    return Post(
      id: data['_id'],
      title: data['title'],
      description: data['description'],
      isUserPublic: data['isUserPublic'],
      userId: data['userId']['_id'],
      postedAt: data['createdAt'],
      username: data['userId']['username'],
      image: data['image'],
      userImage: data['userId']['image'],
      likeCount: data['likeCount'],
      commentsCount: data['commentCount'],
      likeStatus: data['likeType'],
      tags: List.generate(
        data['tags'].length,
        (index) => data['tags'][index]['name'],
      ),
    );
  }

  // TODO: Update this
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isUserPublic': isUserPublic,
      'tags': tags,
    };
  }
}
