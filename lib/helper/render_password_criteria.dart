import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/typographies.dart';

Widget buildCriteriaRow(String criteria, bool isValid) {
  return Row(
    children: [
      const SizedBox(width: 8),
      Icon(
        isValid ? Icons.check : Icons.close,
        color: isValid ? Colors.green : Colors.red,
      ),
      const SizedBox(width: 5),
      Text(criteria, style: BodyLargeRegular),
    ],
  );
}
