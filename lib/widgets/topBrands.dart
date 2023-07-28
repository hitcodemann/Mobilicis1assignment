import 'package:flutter/material.dart';
import 'package:mobilicis/widgets/brandsBox.dart';

class TopBrands extends StatelessWidget {
  const TopBrands({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _mobileCompList = [
      'apple',
      'samsung',
      'mi',
      'vivo',
      'oppo',
      'Nokia'
    ];
    return Container(
      height: 100,
      color: const Color.fromARGB(255, 249, 248, 248),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _mobileCompList.length,
          itemBuilder: (context, index) {
            return BrandBox(onTap: () {}, imgUrl: _mobileCompList[index]);
          }),
    );
  }
}
