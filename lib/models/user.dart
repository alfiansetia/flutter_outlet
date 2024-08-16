import 'dart:convert';

import 'package:flutter_outlet/features/branch/models/branch.dart';

class User {
  User({
    required this.avatar,
    required this.id,
    required this.name,
    this.phone,
    required this.role,
    required this.isActive,
    required this.branchId,
    this.branch,
  });

  factory User.initial() => User(
        id: 0,
        name: '',
        phone: null,
        avatar: '',
        role: '',
        isActive: false,
        branchId: 0,
      );

  final String avatar;
  final int id;
  final String name;
  final String? phone;
  final String role;
  final bool isActive;
  final int branchId;
  final Branch? branch;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'avatar': avatar});
    result.addAll({'id': id});
    result.addAll({'name': name});
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    result.addAll({'role': role});
    result.addAll({'is_active': isActive});
    result.addAll({'branch_id': branchId});
    if (branch != null) {
      result.addAll({'branch': branch!.toMap()});
    }

    return result;
  }

  User copyWith({
    String? avatar,
    int? id,
    String? name,
    String? phone,
    String? role,
    bool? isActive,
    int? branchId,
    Branch? branch,
  }) {
    return User(
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      branchId: branchId ?? this.branchId,
      branch: branch ?? this.branch,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      avatar: map['avatar'] ?? '',
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      phone: map['phone'],
      role: map['role'] ?? '',
      isActive: map['is_active'] ?? false,
      branchId: map['branch_id']?.toInt() ?? 0,
      branch: map['branch'] != null ? Branch.fromMap(map['branch']) : null,
    );
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(avatar: $avatar, id: $id, name: $name, phone: $phone, role: $role, isActive: $isActive, branchId: $branchId, branch: $branch)';
  }
}
