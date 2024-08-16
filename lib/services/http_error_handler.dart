import 'dart:convert';

import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:http/http.dart' as http;

String httpErrorHandler(http.Response response) {
  String message = '';
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  if (statusCode == 401) {
    AuthRepository().removeData();
  }

  String body = json.decode(response.body)['message'];
  if (body.isNotEmpty) {
    return body;
  }

  if (statusCode == 422) {
    message = json.decode(response.body)['message'];
  } else if (statusCode == 500) {
    message = 'Server Error';
  } else {
    message = reasonPhrase ?? 'Error';
  }
  return message;
}
