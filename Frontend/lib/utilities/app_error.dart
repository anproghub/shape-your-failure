class AppError extends Error {
  int statusCode;
  String message;

  AppError(
    this.statusCode,
    this.message,
  );
}
