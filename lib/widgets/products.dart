import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Products extends StatefulWidget {
  String imgUrl;
  String price;
  String storage;
  String deviceCondition;
  String name;
  String location;
  String date;

  Products(
      {required this.imgUrl,
      required this.date,
      required this.deviceCondition,
      required this.location,
      required this.name,
      required this.price,
      required this.storage,
      super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 750,
        width: 600,
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CachedNetworkImage(
                    imageUrl: widget.imgUrl,
                    height: 100,
                    width: 300,
                  ),
                ),
                Positioned(
                  top: -10,
                  right: -5,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // Add your favorite icon onPressed logic here
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    widget.price,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(widget.name),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          widget.storage,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    Text(
                      "Condition: ${widget.deviceCondition}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        widget.location,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      widget.date,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
