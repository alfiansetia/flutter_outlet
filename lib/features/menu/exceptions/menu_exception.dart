class MenuException implements Exception {
  MenuException([this.message = 'Something went wrong']) {
    message = 'Menu Exception: $message';
  }

  String message;

  @override
  String toString() {
    return message;
  }
}
