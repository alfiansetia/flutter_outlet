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

  // ✅ Coba decode JSON dengan aman
  dynamic decoded;
  try {
    decoded = json.decode(response.body);
  } catch (e) {
    // kalau bukan JSON (mungkin HTML), kasih pesan error umum
    return 'Invalid response format (HTML or non-JSON returned)';
  }

  // ✅ Cek kalau ternyata hasil decode bukan Map
  if (decoded is! Map || decoded['message'] == null) {
    return 'Unexpected response structure';
  }

  // ✅ Ambil message dari JSON
  String bodyMessage = decoded['message'].toString();

  if (bodyMessage.isNotEmpty) {
    return bodyMessage;
  }

  // ✅ Fallback berdasarkan status code
  if (statusCode == 422) {
    message = decoded['message'] ?? 'Validation Error';
  } else if (statusCode == 500) {
    message = 'Server Error';
  } else {
    message = reasonPhrase ?? 'Error';
  }

  return message;
}
