class SettingException implements Exception {
  SettingException([this.message = 'Something went wrong']) {
    message = 'Setting Exception: $message';
  }

  String message;

  @override
  String toString() {
    return message;
  }
}
