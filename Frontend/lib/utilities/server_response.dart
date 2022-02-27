class ServerResponse {
  late int statusCode;
  late String status;
  late String message;

  ServerResponse({
    required this.statusCode,
    required this.status,
    required this.message,
  });
}
