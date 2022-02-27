class ReportPost {
  String? postId;
  int? type;

  ReportPost({
    this.postId,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}
