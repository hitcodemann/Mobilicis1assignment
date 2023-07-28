import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandBox extends StatelessWidget {
  // final bool isSelected;
  final String imgUrl;
  final Function() onTap;

  const BrandBox({required this.onTap, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/icons/$imgUrl.svg',

              // color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
