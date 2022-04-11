import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:personalshopper/size_config.dart';

class carouselSlider extends StatelessWidget {
  const carouselSlider({
    Key? key,
    required this.imgList,
  }) : super(key: key);

  final List<String> imgList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 16 / 9,
            enableInfiniteScroll: true,
            viewportFraction: 1,
          ),
          items: imgList
              .map((item) => Container(
                  child: Center(
                      child:
                          Image.network(item, fit: BoxFit.cover, width: 1000))))
              .toList(),
        ),
      ),
    );
  }
}
