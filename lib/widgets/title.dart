import 'package:flutter/material.dart';

class BoxTitle extends StatelessWidget {
  final String title;
  const BoxTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}
