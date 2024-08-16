import 'package:flutter/material.dart';
import 'package:flutter_outlet/core/components/spaces.dart';

Widget labelValue({required String label, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(),
      ),
      const SpaceHeight(5.0),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
