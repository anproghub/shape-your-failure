class Reaction {
  String? id;
  String? postId;
  String? username;
  String? reactionType;

  Reaction({
    this.id,
    this.postId,
    this.username,
    this.reactionType = 'Love',
  });

  static Reaction fromJson(data) {
    return Reaction(
      reactionType: data['type'],
      postId: data['postId'],
      username: data['userId']['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': reactionType,
      'postId': postId,
    };
  }
}
