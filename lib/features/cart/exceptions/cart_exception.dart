class CartException implements Exception {
  CartException([this.message = 'Something went wrong']) {
    message = 'Cart Exception: $message';
  }

  String message;

  @override
  String toString() {
    return message;
  }
}
