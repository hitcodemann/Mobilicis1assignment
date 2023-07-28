import 'package:flutter/material.dart';
import 'package:mobilicis/models/shopModel.dart';

class BoxWidget extends StatelessWidget {
  final ShopBox data;

  const BoxWidget({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white24,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, size: 40),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.text,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
