class AuthException implements Exception {
  AuthException([this.message = 'Something went wrong']) {
    // message = 'Error Exception: $message';
    message = message;
  }

  String message;

  @override
  String toString() {
    return message;
  }
}
