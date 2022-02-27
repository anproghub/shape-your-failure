class ReportComment {
  String? commentId;
  String? postId;
  int? type;
  ReportComment({
    this.commentId,
    this.type,
    this.postId,
  });
  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}
