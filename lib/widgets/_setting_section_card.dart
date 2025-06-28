import 'package:flutter/material.dart';
import 'package:note_book/shared/_themes.dart';

Widget buildSectionCard(
  BuildContext context,
  String title,
  List<Widget> children,
) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    ),
  );
}
