class ProfileException implements Exception {
  ProfileException([this.message = 'Something went wrong']) {
    message = 'Profile Exception: $message';
  }

  String message;

  @override
  String toString() {
    return message;
  }
}
