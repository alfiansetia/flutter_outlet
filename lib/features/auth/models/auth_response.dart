import 'dart:convert';

import 'package:flutter_outlet/models/user.dart';

class AuthResponse {
  AuthResponse({
    required this.jwtToken,
    required this.user,
  });

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        jwtToken: json["access_token"],
        user: User.fromMap(json["user"]),
      );

  final String jwtToken;
  final User user;

  factory AuthResponse.initial() => AuthResponse(
        jwtToken: '',
        user: User(
          id: 0,
          name: '',
          phone: '',
          avatar: '',
          role: 'user',
          isActive: false,
          branchId: 0,
        ),
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "access_token": jwtToken,
        "user": user.toMap(),
      };
}
