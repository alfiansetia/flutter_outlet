import 'package:flutter/material.dart';
import 'package:flutter_outlet/core/constants/colors.dart';

enum AlertStatus { success, error }

class Alert {
  Alert({required this.status, required this.message, required this.context});

  final AlertStatus status;
  final String message;
  final BuildContext context;

  void show() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            status == AlertStatus.success ? AppColors.green : AppColors.red,
      ),
    );
  }
}
