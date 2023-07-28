import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  VoidCallback onPress;
  String titleBtn;
  bool isSelected;
  FilterButton(
      {super.key,
      required this.onPress,
      required this.titleBtn,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: isSelected ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(titleBtn),
      ),
    );
  }
}
